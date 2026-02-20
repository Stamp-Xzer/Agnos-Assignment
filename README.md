========================================================================
HOSPITAL MIDDLEWARE API
========================================================================

This project is a Backend API service developed as part of the Agnos Candidate Assignment.
It acts as a middleware to search and manage patient information across different hospitals,
ensuring strict data isolation between hospital staff.

------------------------------------------------------------------------
ROCKET TECH STACK
------------------------------------------------------------------------
- Language:       Golang (Gin Framework)
- Database:       PostgreSQL
- Infrastructure: Docker & Docker Compose
- Web Server:     Nginx (Reverse Proxy)
- Testing:        Unit Tests & Integration Tests (Node.js)

------------------------------------------------------------------------
PROJECT STRUCTURE
------------------------------------------------------------------------
agnos-backend/
|-- cmd/                # Application entry point
|-- config/             # Configuration logic
|-- controllers/        # HTTP Handlers (API Logic)
|-- database/           # Database connection & setup
|-- middleware/         # Auth middleware (JWT)
|-- models/             # GORM Database Models
|-- nginx/              # Nginx Configuration
|-- tests/              # Unit & Integration tests
|-- utils/              # Helper functions (Hash, Token, Response)
|-- docker-compose.yml  # Container orchestration
|-- Dockerfile          # Go application build script
|-- main.go             # Main application file

------------------------------------------------------------------------
PREREQUISITES
------------------------------------------------------------------------
1. Docker Desktop installed
2. Node.js (Optional, for running integration tests locally)

------------------------------------------------------------------------
HOW TO RUN (DOCKER)
------------------------------------------------------------------------

1. Clone the repository:
   git clone https://github.com/Stamp-Xzer/agnos-backend.git
   cd agnos-backend

2. Start the application:
   docker-compose up -d --build
   
   (This command will start Go API, PostgreSQL, and Nginx containers.)

3. Check running services:
   docker ps

   You should see 3 containers: agnos_nginx, agnos_app, agnos_postgres.

4. API Access:
   The API is accessible via port 80 (Nginx):
   Base URL: http://localhost

------------------------------------------------------------------------
HOW TO TEST
------------------------------------------------------------------------

[1] Unit Tests (Go)
To run unit tests for controllers and logic:
   go test ./tests/...

[2] Integration Tests (Node.js Script)
A script is provided to simulate real-world scenarios (Register -> Login -> Search):
   
   # Install dependencies (first time only)
   cd tests
   npm install axios colors

   # Run test script
   node test-api.js

*Make sure the Docker environment is running before executing integration tests.*

------------------------------------------------------------------------
API DOCUMENTATION
------------------------------------------------------------------------

1. POST /staff/create
   Description: Register a new staff member
   Auth Required: NO

2. POST /staff/login
   Description: Login to get JWT Token
   Auth Required: NO

3. GET /patient/search
   Description: Search patients (within same hospital only)
   Auth Required: YES (Bearer Token)

   Example Request:
   GET /patient/search?first_name=Somchai
   Authorization: Bearer <YOUR_TOKEN>

------------------------------------------------------------------------
NOTE
------------------------------------------------------------------------
The database is initialized with empty tables. You may need to use the 
Register API to create a staff user, or insert mock data into the database 
to test the search functionality fully.
