
from django.shortcuts import render
from AdminWeb.models import Parameters
from datetime import date
from AdminWeb.models import Support
from AdminWeb.models import User
from AdminWeb.models import Reservation
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.hashers import make_password
from AdminWeb.models import Marker
from django.http import JsonResponse
from django.core.mail import send_mail
from django.contrib import messages
from django.http import HttpResponseRedirect
from django.urls import reverse
import random



today = date.today()



def index(request):
 is_authenticated = request.session.get('is_authenticated', False)

 if is_authenticated:
  
  

    return render(request, 'index.html')
 else:
                messages.error(request, 'You are not authorized to access this page, Sorry!')
                return redirect('sign-in')



def signin(request):
    request.session['is_authenticated'] = False
    if request.method == 'POST':
        email = request.POST.get('email') 
        password = request.POST.get('Password')
        try:
            user = User.objects.get(Email=email)
            if user.check_password(password):
                if user.Type == 'Admin':
                     messages.success(request, 'You have been signed in successfully!')
                     request.session['is_authenticated'] = True
                     return redirect(('index'))
            else:
                messages.error(request, 'Invalid email or password!')
        except User.DoesNotExist:
            messages.error(request, 'Invalid email or password!')
        return redirect('sign-in')
    else:
        return render(request, 'sign-in.html')


def ForgetPass(request):
    if request.method == 'POST':
        email = request.POST.get('email') 
        try:
            user = User.objects.get(Email=email)
            if user.Type == 'Admin':
              send_mail(
                    'Reset Password',
                    'Please reset your password by following the instructions provided.',
                    'settings.EMAIL_HOST_USER',
                    [email],
                    fail_silently=False,
                )
              return render(request, 'sign-in.html')
            else:
             messages.error(request, 'You are not an Admin!')
            return redirect('ForgetPass')
        
        except User.DoesNotExist:
         messages.error(request, 'Email Does not Exist!')
        return redirect('ForgetPass') 
    else:
        return render(request, 'ForgetPass.html')

def UpdateParameters(request):
      is_authenticated = request.session.get('is_authenticated', False)

      if is_authenticated:
  
        num_of_Sbackup_vehicles =Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='backup').first()
        num_of_Sbackup_vehicles  = num_of_Sbackup_vehicles .TotalNumberofVehicles
        num_of_Dbackup_vehicles =Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='backup').first()
        num_of_Dbackup_vehicles  = num_of_Dbackup_vehicles .TotalNumberofVehicles
        num_of_SWalkin_vehicles =Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='walkin').first()
        num_of_SWalkin_vehicles = num_of_SWalkin_vehicles .TotalNumberofVehicles
        num_of_DWalkin_vehicles =Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='walkin').first()
        num_of_DWalkin_vehicles = num_of_DWalkin_vehicles .TotalNumberofVehicles
        SingleV=Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='visitor').first()
        SingleV=SingleV.TotalNumberofVehicles
        DoubleV=Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='visitor').first()
        DoubleV=DoubleV.TotalNumberofVehicles
        LocationMarker=Marker.objects.first()
        lat=LocationMarker.Latitude
        long=LocationMarker.Longitude

        context = {'num_of_Sbackup_vehicles': num_of_Sbackup_vehicles,'num_of_Dbackup_vehicles':num_of_Dbackup_vehicles,
                'num_of_SWalkin_vehicles':num_of_SWalkin_vehicles,'num_of_DWalkin_vehicles': num_of_DWalkin_vehicles,"SingleV":SingleV,'DoubleV':DoubleV,'Latitude':lat,'Longitude':long}
        
        if request.method == 'POST':
            num_of_Sbackup_vehicles= request.POST.get('num_of_Sbackup_vehicles')
            num_of_SWalkin_vehicles = request.POST.get('num_of_SWalkin_vehicles')
            num_of_Dbackup_vehicles= request.POST.get('num_of_Dbackup_vehicles')
            num_of_DWalkin_vehicles = request.POST.get('num_of_DWalkin_vehicles')
            SingleV=request.POST.get('SingleV')
            DoubleV=request.POST.get('DoubleV')
            Latitude=request.POST.get('Latitude')
            Longitude=request.POST.get('Longitude')

            
            Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='backup').update(
            TotalNumberofVehicles=num_of_Sbackup_vehicles
            )
            Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='backup').update(
            TotalNumberofVehicles=num_of_Dbackup_vehicles
            )
            Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='walkin').update(
            TotalNumberofVehicles=num_of_SWalkin_vehicles
            )
            Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='walkin').update(
            TotalNumberofVehicles=num_of_DWalkin_vehicles
            )
            Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='visitor').update(
            TotalNumberofVehicles=SingleV
            )
            Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='visitor').update(
            TotalNumberofVehicles=DoubleV
            )

            Marker.objects.update(
                Latitude=Latitude,
                Longitude=Longitude)
        
            
            return redirect('index') 

        else:
         return render(request, 'UpdateParameters.html', context)
      else:
                messages.error(request, 'You are not authorized to access this page, Sorry!')
                return redirect('sign-in')



def AssignVM(request):
    is_authenticated = request.session.get('is_authenticated', False)

    if is_authenticated:
        if request.method == 'POST':
            full_name = request.POST.get('fullName')
            email = request.POST.get('email')
            password = request.POST.get('password')
            task = request.POST.get('task')
            if User.objects.filter(Email=email, Type="Vehicle manager").exists():
                messages.error(request, 'Email already exists for a vehicle manager.')
            else:
                
            
                    hashed_password = make_password(password)
                    New_VM = User(FullName=full_name, Email=email, Password=hashed_password, Type=task, VerificationStatus="1")
                    New_VM.save()
                    messages.success(request, 'Vehicle manager has been added successfully!')
            

        employees = User.objects.filter(Type="Vehicle manager")
        return render(request, 'AssignVM.html', {'employees': employees})
    else:
                messages.error(request, 'You are not authorized to access this page, Sorry!')
                return redirect('sign-in')


def create_user(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        name = request.POST.get('name')
        password = request.POST.get('password')
        if User.objects.filter(Email=email).exists():
            messages.error =(request,'Email already exists. Please choose a different email.') 
            return redirect('CreateAdmin')
        
        hashed_password = make_password(password)

        user = User(Email=email, Password=hashed_password, Type="Admin", VerificationStatus="1", FullName=name)

        user.save()
        return redirect('sign-in')

    return render(request, 'CreateAdmin.html')


def get_Vehicles_Info(request):
     active_reservations = Reservation.objects.filter(date=today, Status='Active').count()
     Double = Reservation.objects.filter(date=today, Status='Active', VehicleId=1).count()
     Single = Reservation.objects.filter(date=today, Status='Active',VehicleId=2).count()

     reservation_ids_today = Reservation.objects.filter(date=today).values_list('reservationId', flat=True)
     support_count = Support.objects.filter(ReservationId__in=reservation_ids_today).count()
     sudden_stop_count = Support.objects.filter(Message='Sudden stop', ReservationId__in=reservation_ids_today).count()
     empty_battery_count = Support.objects.filter(Message='Empty battery', ReservationId__in=reservation_ids_today).count()
     other_count = Support.objects.exclude(Message__in=['Sudden stop', 'Empty battery'], ReservationId__in=reservation_ids_today).count()
     num_of_Sbackup_vehicles =Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='backup').first()
     num_of_Sbackup_vehicles  = num_of_Sbackup_vehicles .TotalNumberofVehicles
     num_of_Dbackup_vehicles =Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='backup').first()
     num_of_Dbackup_vehicles  = num_of_Dbackup_vehicles .TotalNumberofVehicles
     num_of_backup_vehicles = (num_of_Sbackup_vehicles+num_of_Dbackup_vehicles)-support_count

     AllSupport = Support.objects.filter(ReservationId__in=reservation_ids_today, AssignedTo__isnull=True).values()
     AllSupportWithUser = []

     vehicle_managers = User.objects.filter(Type='Vehicle manager')
     assigned_user_ids = Support.objects.filter(AssignedTo__isnull=False).values_list('AssignedTo', flat=True)


     for support in AllSupport:
            available_managers = vehicle_managers.exclude(userID__in=assigned_user_ids)
            reservation = Reservation.objects.get(reservationId=support['ReservationId'])
            user = User.objects.get(pk=reservation.userId)
            support['visitor_name'] = user.FullName
            if available_managers.exists():
                AssignedVM = random.choice(available_managers)
                support['Assigned_to'] = AssignedVM.FullName
                AllSupportWithUser.append(support)
                support_obj = Support.objects.get(supportID=support['supportID'])
                support_obj.AssignedTo = AssignedVM.userID
                support_obj.save()
                assigned_user_ids = Support.objects.filter(AssignedTo__isnull=False).values_list('AssignedTo', flat=True)
            else:
                support['Assigned_to'] = None
                AllSupportWithUser.append(support)

     latitude_values = [marker['Latitude'] for marker in AllSupportWithUser]
     longitude_values = [marker['Longitude'] for marker in AllSupportWithUser]

     message = ', '.join(str(marker['supportID']) for marker in AllSupportWithUser)


     data = {'AllSupport':list(AllSupportWithUser),'Active': active_reservations,'support_count':support_count,'num_of_backup_vehicles':num_of_backup_vehicles,'latitude_values':latitude_values,'longitude_values':longitude_values,'message':message,'Sudden':sudden_stop_count,'Empty':empty_battery_count,'other':other_count,'Double':Double,'Single':Single}
     return JsonResponse(data)




def deleteVM(request,id):
    if request.method == 'POST':
        Vm=User.objects.get(pk=id)
        Vm.delete()
    return HttpResponseRedirect((reverse('AssignVM')))

def delete_Support(request):
    if request.method == 'POST':
        support_id = request.POST.get('supportId')
        try:
            Support.objects.filter(supportID=support_id).delete()
            return JsonResponse({'success': True})
        except Support.DoesNotExist:
            return JsonResponse({'success': False, 'error': 'Support not found'})
    
    return JsonResponse({'success': False, 'error': 'Invalid request'})