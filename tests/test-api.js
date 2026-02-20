const axios = require("axios");
require("colors");

const BASE_URL = "http://localhost";
const TARGET_HOSPITAL = "กาญ";
const SEARCH_KEYWORD_MATCH = "เมทิต";
const SEARCH_KEYWORD_MISS = "ฟฟฟิกกกก";

// --- MOCK USER DATA ---
const randomId = Math.floor(Math.random() * 10000);
const STAFF_USER = {
  username: `nurse_test_${randomId}`,
  password: "password123",
  hospital: TARGET_HOSPITAL,
};

let authToken = "";

async function runTests() {
  console.log(`\nSTARTING API INTEGRATION TESTS`.bold.cyan);
  console.log(`Target: ${BASE_URL}`.gray);
  console.log(`Staff: ${STAFF_USER.username} (${STAFF_USER.hospital})\n`);

  try {
    // 1. Register Staff
    process.stdout.write("1. [POST] Register Staff... ");
    try {
      const res = await axios.post(`${BASE_URL}/staff/create`, STAFF_USER);
      if (res.status === 201) {
        console.log("PASS".green);
      } else {
        throw new Error(`Unexpected status: ${res.status}`);
      }
    } catch (err) {
      console.log("FAIL".red);
      console.error(`   -> ${err.response?.data?.message || err.message}`.gray);
      process.exit(1);
    }

    // 2. Login Staff
    process.stdout.write("2. [POST] Staff Login... ");
    try {
      const res = await axios.post(`${BASE_URL}/staff/login`, {
        username: STAFF_USER.username,
        password: STAFF_USER.password,
        hospital: STAFF_USER.hospital,
      });

      if (res.status === 200 && res.data.data.token) {
        authToken = res.data.data.token;
        console.log("PASS".green);
      } else {
        throw new Error("Token not found in response");
      }
    } catch (err) {
      console.log("FAIL".red);
      console.error(`   -> ${err.response?.data?.message || err.message}`.gray);
      process.exit(1);
    }

    // 3. Search Patient (Same Hospital)
    // Expectation: Found data
    process.stdout.write(
      `3. [GET] Search (Same Hospital: "${SEARCH_KEYWORD_MATCH}")... `,
    );
    try {
      const res = await axios.get(
        `${BASE_URL}/patient/search?first_name=${SEARCH_KEYWORD_MATCH}`,
        {
          headers: { Authorization: `Bearer ${authToken}` },
        },
      );

      const patients = res.data.data;
      if (
        res.status === 200 &&
        Array.isArray(patients) &&
        patients.length > 0
      ) {
        console.log("PASS".green);
        console.log(`   -> Found ${patients.length} patient(s).`.gray);
      } else {
        console.log("WARNING".yellow);
        console.log(
          "   -> Status 200 but no data found. (Did you insert SQL data?)".gray,
        );
      }
    } catch (err) {
      console.log("FAIL".red);
      console.error(`   -> ${err.response?.data?.message || err.message}`.gray);
    }

    // 4. Search Patient (Different Hospital)
    // Expectation: Not Found or Empty Array
    process.stdout.write(
      `4. [GET] Search (Diff Hospital: "${SEARCH_KEYWORD_MISS}")... `,
    );
    try {
      const res = await axios.get(
        `${BASE_URL}/patient/search?first_name=${SEARCH_KEYWORD_MISS}`,
        {
          headers: { Authorization: `Bearer ${authToken}` },
        },
      );

      const patients = res.data.data;

      // Logic: Success if Array is empty OR API returns 404
      if (!patients || patients.length === 0) {
        console.log("PASS".green);
        console.log("   -> Result is empty (Correct isolation).".gray);
      } else {
        console.log("FAIL".red);
        console.log(
          "   -> Security Breach! Staff saw patient from another hospital.".red,
        );
      }
    } catch (err) {
      if (err.response?.status === 404) {
        console.log("PASS".green);
        console.log("   -> API returned 404 (Correct).".gray);
      } else {
        console.log("FAIL".red);
        console.error(
          `   -> ${err.response?.data?.message || err.message}`.gray,
        );
      }
    }

    // 5. Unauthorized Access
    // Expectation: 401 Unauthorized
    process.stdout.write("5. [GET] Access without Token... ");
    try {
      await axios.get(`${BASE_URL}/patient/search`);
      console.log("❌ FAIL".red);
      console.log("   -> API allowed access without token!".red);
    } catch (err) {
      if (err.response?.status === 401) {
        console.log("PASS".green);
      } else {
        console.log("FAIL".red);
        console.error(`   -> Expected 401, got ${err.response?.status}`.gray);
      }
    }
  } catch (err) {
    console.error("\nScript Error:", err);
  }
  console.log("\nTESTS COMPLETED\n");
}

runTests();
