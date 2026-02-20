CREATE TABLE staffs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    hospital VARCHAR(100) NOT NULL
);

CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    first_name_th VARCHAR(100),
    last_name_th VARCHAR(100),
    first_name_en VARCHAR(100),
    last_name_en VARCHAR(100),
    national_id VARCHAR(20) UNIQUE,
    passport_id VARCHAR(20),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    gender VARCHAR(10),
    hospital VARCHAR(100) NOT NULL
);

CREATE INDEX idx_staff_username ON staffs(username);
CREATE INDEX idx_patient_hospital ON patients(hospital);
CREATE INDEX idx_patient_national_id ON patients(national_id);