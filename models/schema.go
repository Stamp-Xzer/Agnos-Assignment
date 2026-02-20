package models

import "gorm.io/gorm"

type Staffs struct {
	gorm.Model
	Username string `json:"username" gorm:"unique;not null"`
	Password string `json:"password" gorm:"not null"`
	Hospital string `json:"hospital" gorm:"not null"`
}

type Patient struct {
	gorm.Model
	FirstNameTH  string `json:"first_name_th"`
	MiddleNameTH string `json:"middle_name_th"`
	LastNameTH   string `json:"last_name_th"`
	FirstNameEN  string `json:"first_name_en"`
	MiddleNameEN string `json:"middle_name_en"`
	LastNameEN   string `json:"last_name_en"`
	DateOfBirth string `json:"date_of_birth"`
	PatientHN   string `json:"patient_hn"`   
	NationalID  string `json:"national_id" gorm:"unique"`
	PassportID  string `json:"passport_id"`
	Phone  string `json:"phone_number"`
	Email  string `json:"email"`
	Gender string `json:"gender"`
	Hospital string `json:"hospital" gorm:"index"`
}