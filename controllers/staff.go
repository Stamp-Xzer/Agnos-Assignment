package controllers

import (
	"agnos-backend/database"
	"agnos-backend/models"
	"agnos-backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// POST /staff/create
func CreateStaff(c *gin.Context) {
	var input struct {
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
		Hospital string `json:"hospital" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.Error(c, http.StatusBadRequest, "4000", "ข้อมูลไม่ครบถ้วน: "+err.Error())
		return
	}

	hashedPassword, _ := utils.HashPassword(input.Password)
	user := models.Staffs{
		Username: input.Username,
		Password: hashedPassword,
		Hospital: input.Hospital,
	}
	if err := database.DB.Create(&user).Error; err != nil {
		utils.Error(c, http.StatusInternalServerError, "5000", "บันทึกข้อมูลไม่สำเร็จ: "+err.Error())
		return
	}

	utils.Success(c, http.StatusCreated, "2001", "สร้าง Staff สำเร็จ", user)
}

// POST /staff/login
func Login(c *gin.Context) {
	var input struct {
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
		Hospital string `json:"hospital" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		utils.Error(c, http.StatusBadRequest, "4000", "ข้อมูลไม่ครบถ้วน")
		return
	}

	var user models.Staffs
	if err := database.DB.Where("username = ?", input.Username).First(&user).Error; err != nil {
		utils.Error(c, http.StatusUnauthorized, "4004", "ไม่พบผู้ใช้งาน")
		return
	}

	if !utils.CheckPasswordHash(input.Password, user.Password) {
		utils.Error(c, http.StatusUnauthorized, "4001", "รหัสผ่านผิด")
		return
	}
	
	if err := database.DB.Where("username = ? AND hospital = ?", input.Username,input.Hospital).First(&user).Error; err != nil {
		utils.Error(c, http.StatusUnauthorized, "4004", "ไม่พบผู้ใช้งาน")
		return
	}

	token, _ := utils.GenerateToken(user.ID, user.Hospital)
	utils.Success(c, http.StatusOK, "2000", "เข้าสู่ระบบสำเร็จ", gin.H{"token": token})
}

// GET /patient/search/:id
func SearchPatientByID(c *gin.Context) {
	staffHospital, _ := c.Get("hospital")
	id := c.Param("id")

	var patients []models.Patient
	tx := database.DB.Model(&models.Patient{})

	tx = tx.Where("hospital = ?", staffHospital)
		tx = tx.Where(
		database.DB.Where("national_id = ?", id).
		Or("passport_id = ?", id),
	)
	
	tx.Find(&patients)
	utils.Success(c, http.StatusOK, "2000", "ค้นหาสำเร็จ", patients)
}

// GET /patient/search
func SearchPatient(c *gin.Context) {
	staffHospital, _ := c.Get("hospital")
	var patients []models.Patient
	tx := database.DB.Model(&models.Patient{})
	tx = tx.Where("hospital = ?", staffHospital)
	if v := c.Query("national_id"); v != "" {
		tx = tx.Where("national_id = ?", v)
	}
	if v := c.Query("passport_id"); v != "" {
		tx = tx.Where("passport_id = ?", v)
	}
	if v := c.Query("patient_hn"); v != "" {
		tx = tx.Where("patient_hn = ?", v)
	}
	if v := c.Query("first_name"); v != "" {
		tx = tx.Where(database.DB.Where("first_name_th LIKE ?", "%"+v+"%").Or("first_name_en LIKE ?", "%"+v+"%"))
	}
	if v := c.Query("middle_name"); v != "" {
		tx = tx.Where(database.DB.Where("middle_name_th LIKE ?", "%"+v+"%").Or("middle_name_en LIKE ?", "%"+v+"%"))
	}
	if v := c.Query("last_name"); v != "" {
		tx = tx.Where(database.DB.Where("last_name_th LIKE ?", "%"+v+"%").Or("last_name_en LIKE ?", "%"+v+"%"))
	}
	if v := c.Query("email"); v != "" {
		tx = tx.Where("email LIKE ?", "%"+v+"%")
	}
	if v := c.Query("phone_number"); v != "" {
		tx = tx.Where("phone_number LIKE ?", "%"+v+"%")
	}
	if v := c.Query("date_of_birth"); v != "" {
		tx = tx.Where("date_of_birth = ?", v)
	}
	if v := c.Query("gender"); v != "" {
		tx = tx.Where("gender = ?", v)
	}
	result := tx.Find(&patients)

	if result.Error != nil {
		utils.Error(c, http.StatusInternalServerError, "5000", "เกิดข้อผิดพลาดในการค้นหา")
		return
	}

	utils.Success(c, http.StatusOK, "2000", "ค้นหาสำเร็จ", patients)
}