BEGIN;

CREATE TABLE IF NOT EXISTS public.staffs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    hospital VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.patients (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    first_name_th VARCHAR(100),
    middle_name_th VARCHAR(100),
    last_name_th VARCHAR(100),
    first_name_en VARCHAR(100),
    middle_name_en VARCHAR(100),
    last_name_en VARCHAR(100),
    date_of_birth DATE,
    patient_hn VARCHAR(50),
    national_id VARCHAR(20),
    passport_id VARCHAR(20),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    gender VARCHAR(10),
    hospital VARCHAR(100) NOT NULL
);

CREATE INDEX idx_staff_username ON public.staffs(username);
CREATE INDEX idx_patient_hospital ON public.patients(hospital);
CREATE INDEX idx_patient_national_id ON public.patients(national_id);

INSERT INTO public.staffs (id, created_at, updated_at, deleted_at, username, password, hospital) VALUES 
(1, '2026-02-20 13:29:55.601+00', '2026-02-20 13:29:55.601+00', NULL, 'admin', '$2a$14$gq4tO90ARDW.3wCS7lfNKOl6QvOOuhcv/mh.DVukDHFekcySmB4Yy', 'กาญ'),
(6, '2026-02-20 17:06:07.523+00', '2026-02-20 17:06:07.523+00', NULL, 'admin2', '$2a$14$QvUc.XoIqa24/XZ0dN4.YOdm5jyIoi6ToSzdozfMaMkR1i9ODqtqu', 'กาญ'),
(7, '2026-02-20 17:06:40.330+00', '2026-02-20 17:06:40.330+00', NULL, 'admin4', '$2a$14$UYYnztMooelUWgxFcPnt/eObs6nvvawhrSAIHvy.2Zm4ezDFUa2mq', 'ศิริราช'),
(8, '2026-02-20 17:16:50.455+00', '2026-02-20 17:16:50.455+00', NULL, 'nurse_test_8438', '$2a$14$B.SdqHwG4497Lj.dbFR6N.gFmUehIFLQ9OUgYJCmbA4rRLeF6oVe2', 'กาญ'),
(9, '2026-02-20 17:17:26.614+00', '2026-02-20 17:17:26.614+00', NULL, 'nurse_test_6866', '$2a$14$CfetqlOoJxDI4T20ocVTJuY4hPhXkaDjtFgeuO7e5RluQyF11.n26', 'กาญ'),
(10, '2026-02-20 17:17:47.628+00', '2026-02-20 17:17:47.628+00', NULL, 'nurse_test_1730', '$2a$14$tvNI3WvR1pw/eCuC79xXveN1BFDyt0wgiG6aNEbjIUXbNq1F/I6ui', 'กาญ');

INSERT INTO public.patients (id, created_at, updated_at, deleted_at, first_name_th, middle_name_th, last_name_th, first_name_en, middle_name_en, last_name_en, date_of_birth, patient_hn, national_id, passport_id, phone_number, email, gender, hospital) VALUES 
(1, '2026-02-20 16:54:11.467+00', '2026-02-20 16:54:11.467+00', NULL, 'เมทิต', '', 'จันทฤทธิ์', 'Methit', NULL, 'Chantharith', NULL, 'PT00001', '1122', '112233', '0931280344', 'admin@admin.com', 'M', 'กาญ'),
(2, '2024-02-21 03:00:00+00', '2024-02-21 03:00:00+00', NULL, 'เมทิต', '', 'จันทฤทธิ์', 'Methit', NULL, 'Chantharith', '1990-05-15', 'HN001', '1100400001111', 'PASS001', '0931280344', 'methit@example.com', 'M', 'กาญ'),
(3, '2024-02-21 03:05:00+00', '2024-02-21 03:05:00+00', NULL, 'สมชาย', 'ศักดิ์', 'ใจดี', 'Somchai', 'Sak', 'Jaidee', '1985-12-01', 'HN002', '1100400002222', 'PASS002', '0812345678', 'somchai@test.com', 'M', 'กาญ'),
(4, '2024-02-21 03:10:00+00', '2024-02-21 03:10:00+00', NULL, 'สมหญิง', '', 'รักเรียน', 'Somying', NULL, 'Rakrian', '1992-03-20', 'HN003', '1100400003333', NULL, '0899876543', 'somying@test.com', 'F', 'กาญ'),
(5, '2024-02-21 03:15:00+00', '2024-02-21 03:15:00+00', NULL, 'จอห์น', '', 'โด', 'John', '', 'Doe', '1980-01-01', 'HN004', NULL, 'USA123456', '0651112222', 'john.doe@email.com', 'M', 'กาญ'),
(6, '2024-02-21 04:00:00+00', '2024-02-21 04:00:00+00', NULL, 'แอบเนียน', '', 'มาตรวจ', 'Abnian', NULL, 'Matruat', '1995-07-07', 'HN999', '9999999999999', 'PASS999', '0909998888', 'spy@other.com', 'F', 'ศิริราช'),
(7, '2024-02-21 04:05:00+00', '2024-02-21 04:05:00+00', NULL, 'เมทิต', '', 'คนละคน', 'Methit', NULL, 'Konlakon', '1991-01-01', 'HN888', '8888888888888', 'PASS888', '0912345678', 'methit.fake@other.com', 'M', 'ศิริราช');

SELECT pg_catalog.setval('public.staffs_id_seq', 10, true);
SELECT pg_catalog.setval('public.patients_id_seq', 7, true);

COMMIT;