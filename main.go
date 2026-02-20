package main

import (
	"agnos-backend/controllers"
	"agnos-backend/database"
	"agnos-backend/middleware"

	"github.com/gin-gonic/gin"
)

func main() {
	database.ConnectDB()
	r := gin.Default()
	r.POST("/staff/create", controllers.CreateStaff)
	r.POST("/staff/login", controllers.Login)
	protected := r.Group("/")
	protected.Use(middleware.AuthRequired())
	{
		protected.GET("/patient/search/:id", controllers.SearchPatientByID)
		protected.GET("/patient/search", controllers.SearchPatient)
	}
	r.Run(":8080")
}