
from django.shortcuts import get_object_or_404, render
from AdminWeb.models import Parameters
from datetime import date
from AdminWeb.models import Support
from AdminWeb.models import User
from AdminWeb.models import Reservation
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.hashers import make_password
from AdminWeb.models import Marker
from django.http import JsonResponse, QueryDict
from django.core.mail import send_mail
from django.contrib import messages
import random
from django.shortcuts import render, redirect
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.views import PasswordResetView, PasswordResetConfirmView
from django.contrib.auth.forms import SetPasswordForm
from django.contrib import messages
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode


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
            messages.error(request, 'Email does not exist!')
        return redirect('sign-in')
    else:
        return render(request, 'sign-in.html')


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
            if request.POST.get('update'): 
 
 
                full_name = request.POST.get('fullName') 
                email = request.POST.get('email') 
                task = request.POST.get('task') 
               
 
                 
                usr_obj=User.objects.filter(userID=int(request.POST.get("pk"))).last() 
                usr_obj.FullName=full_name 
                usr_obj.Email=email 
                usr_obj.Type=task 
                usr_obj.VerificationStatus="1" 
               
                usr_obj.save() 
                msg="Vehicle manager's information has been updated successfully!" 
                return JsonResponse({'status':'1','msg':msg}) 
 
            full_name = request.POST.get('fullName') 
            email = request.POST.get('email') 
            password = request.POST.get('password') 
            task = request.POST.get('task') 
            if User.objects.filter(Email=email, Type="Vehicle manager").exists(): 
                msg="Email already exists for a vehicle manager." 
                return JsonResponse({'status':'2','msg':msg}) 
                
            else: 
                    hashed_password = make_password(password) 
                    hashed_password = hashed_password[7:]
                    New_VM = User(FullName=full_name, Email=email, Password=hashed_password, Type=task, VerificationStatus="1") 
                    New_VM.save() 
                    msg="Vehicle manager has been added successfully!" 
                    return JsonResponse({'status':'1','msg':msg})
 
        elif request.method == 'DELETE': 
            id = int(QueryDict(request.body).get('id')) 
            obj = get_object_or_404(User,pk = id) 
            obj.delete() 
            msg="Vehicle manager has been deleted successfully!" 
            return JsonResponse({'status':'success','msg':msg}) 
 
 
        elif request.GET.get("id") and request.GET.get("edite") :  
                from django.core import serializers 
                try: 
                    data = User.objects.filter(userID=int(request.GET.get("id"))) 
                     
                    print(serializers.serialize("json", data)) 
                    return JsonResponse( 
                        { 
                            "status": 1,  
                            "data": serializers.serialize("json", data), 
                        } 
                    ) 
                except Exception as e: 
                 
                    return JsonResponse({"status": 0, "message":"Error in fetching the data"}) 
 
 
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
     support_count = Support.objects.filter(ReservationId__in=reservation_ids_today,Solved=0).count()
     sudden_stop_count = Support.objects.filter(Message='Sudden stop', ReservationId__in=reservation_ids_today,Solved=0).count()
     empty_battery_count = Support.objects.filter(Message='Empty battery', ReservationId__in=reservation_ids_today,Solved=0).count()
     other_count = Support.objects.exclude(Message__in=['Sudden stop', 'Empty battery']).filter(ReservationId__in=reservation_ids_today, Solved=0).count()
     num_of_Sbackup_vehicles =Parameters.objects.filter(VehicleType='Single', VehicleDedicatedTo='backup').first()
     num_of_Sbackup_vehicles  = num_of_Sbackup_vehicles .TotalNumberofVehicles
     num_of_Dbackup_vehicles =Parameters.objects.filter(VehicleType='Double', VehicleDedicatedTo='backup').first()
     num_of_Dbackup_vehicles  = num_of_Dbackup_vehicles .TotalNumberofVehicles
     us_support_count = Support.objects.filter(ReservationId__in=reservation_ids_today,Solved=1).count()
     num_of_backup_vehicles = (num_of_Sbackup_vehicles+num_of_Dbackup_vehicles)-us_support_count

     unsolved_supports = list(Support.objects.filter(ReservationId__in=reservation_ids_today, Solved=0).values())
     solved_supports = list(Support.objects.filter(ReservationId__in=reservation_ids_today, Solved=1).values())
     AllSupport =  unsolved_supports + solved_supports
     AllSupportWithUser = []

     vehicle_managers = User.objects.filter(Type='Vehicle manager')
     assigned_user_ids = Support.objects.filter(AssignedTo__isnull=False,Solved=0).values_list('AssignedTo', flat=True)

     for support in AllSupport:
            reservation = Reservation.objects.get(reservationId=support['ReservationId'])
            user = User.objects.get(pk=reservation.userId)
            support['visitor_name'] = user.FullName
            if support['AssignedTo'] is not None:
                assigned_manager = User.objects.get(userID=support['AssignedTo'])
                support['Assigned_to'] = assigned_manager.FullName
            else:
                available_managers = vehicle_managers.exclude(userID__in=assigned_user_ids)
                if available_managers.exists():
                    AssignedVM = random.choice(available_managers)
                    support['Assigned_to'] = AssignedVM.FullName
                    support_obj = Support.objects.get(supportID=support['supportID'])
                    support_obj.AssignedTo = AssignedVM.userID
                    support_obj.save()
                else:
                    support['Assigned_to'] = None
            AllSupportWithUser.append(support)


     latitude_values = [marker['Latitude'] for marker in AllSupportWithUser if marker['Solved'] == 0] 
     longitude_values = [marker['Longitude'] for marker in AllSupportWithUser if marker['Solved'] == 0]
     message = ''.join(str(marker['supportID']) for marker in AllSupportWithUser if marker['Solved'] == 0)


     data = {'AllSupport':list(AllSupportWithUser),'Active': active_reservations,'support_count':support_count,'num_of_backup_vehicles':num_of_backup_vehicles,'latitude_values':latitude_values,'longitude_values':longitude_values,'message':message,'Sudden':sudden_stop_count,'Empty':empty_battery_count,'other':other_count,'Double':Double,'Single':Single}
     return JsonResponse(data)



def reset_password(request):
    if request.method == 'POST':
        email = request.POST['email']
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            user = None

        if user is not None:
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            token = default_token_generator.make_token(user)

            reset_url = request.build_absolute_uri(
                f'/reset_password_confirm.html/{uid}/{token}/'
            )

        return redirect('reset_password_done')

    return render(request, 'reset_password.html')

def reset_password_done(request):
    return render(request, 'reset_password_done.html')

def reset_password_confirm(request, uidb64, token):
    try:
        uid = urlsafe_base64_decode(uidb64).decode()
        user = User.objects.get(pk=uid)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist):
        user = None

    if user is not None and default_token_generator.check_token(user, token):
        if request.method == 'POST':
            form = SetPasswordForm(user, request.POST)
            if form.is_valid():
                form.save()
                messages.success(request, 'Your password has been successfully reset. You can now log in with your new password.')
                return redirect('reset_password_complete')
        else:
            form = SetPasswordForm(user)

        return render(request, 'reset_password_confirm.html', {'form': form})

    return redirect('password_reset_invalid')

def reset_password_complete(request):
    return render(request, 'reset_password_complete.html')