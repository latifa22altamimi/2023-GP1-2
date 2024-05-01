from django.db import models
from django.contrib.auth.hashers import check_password, make_password

class Parameters(models.Model):

    ParametersId = models.IntegerField(primary_key=True)
    VehicleType=models.CharField(max_length=6)
    VehicleDedicatedTo=models.CharField(max_length=10)
    TotalNumberofVehicles=models.IntegerField()

    class Meta:
        db_table = 'parameters'
        app_label = 'RehaabWeb'  
  

        
class Marker(models.Model):
     MarkerId = models.AutoField(primary_key=True)
     Latitude = models.FloatField()
     Longitude = models.FloatField()
     
     class Meta:
        db_table = 'markers'
        app_label = 'RehaabWeb'

class User(models.Model):
    userID = models.AutoField(primary_key=True)
    FullName = models.CharField(max_length=30)
    Email = models.EmailField(max_length=200)
    Password = models.CharField(max_length=255)
    Type = models.CharField(max_length=30)
    VerificationStatus = models.IntegerField()

    class Meta:
        db_table = 'users'
        app_label = 'RehaabWeb'

    def check_password(self, password):
        return check_password(password, self.Password)
    

class Reservation(models.Model):
     reservationId = models.AutoField(primary_key=True)
     date=models.CharField(max_length=10)
     VehicleId=models.CharField(max_length=6)
     drivingType=models.CharField(max_length=20)
     driverGender=models.CharField(max_length=20)
     Status=models.CharField(max_length=20)
     userId=models.IntegerField(max_length=20)
     time=models.CharField(max_length=10)
     timestamp=models.DateTimeField()

     class Meta:
        db_table = 'reservation'
        app_label = 'RehaabWeb'    
    



class ManagerReservation(models.Model):
    reservationId = models.AutoField(primary_key=True)
    visitorName=models.CharField(max_length=200)
    VphoneNumber=models.CharField(max_length=20)
    ExpectedFinishTime=models.CharField(max_length=20)	
    ReservedForWaiting=models.IntegerField(max_length=20)
    class Meta:
        db_table = 'managerreservation'
        app_label = 'RehaabWeb' 
  

class Vehicle(models.Model):
    vehicleId=models.AutoField(primary_key=True)
    VehicleType=models.CharField(max_length=6)

    class Meta:
        db_table = 'vehicle'
        app_label = 'RehaabWeb'  

class Support(models.Model):
    supportID= models.IntegerField(primary_key=True)
    ReservationId = models.IntegerField()
    Latitude = models.CharField(max_length=200)
    Longitude = models.CharField(max_length=200)
    Message = models.CharField(max_length=200)
    AssignedTo = models.IntegerField(max_length=11)
    Solved=models.ImageField(max_length=1)
    ReportedAt=models.DateTimeField()

    class Meta:
        db_table = 'support'
        app_label = 'RehaabWeb'  