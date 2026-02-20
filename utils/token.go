package utils

import (
	"time"
	"os"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
)

func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

func GetSecretKey() []byte {
	secret := os.Getenv("JWT_SECRET")
	return []byte(secret)
}


func GenerateToken(userID uint, hospital string) (string, error) {
	claims := jwt.MapClaims{
		"user_id":  userID,
		"hospital": hospital,
		"exp":      time.Now().Add(time.Hour * 1).Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(GetSecretKey())
}