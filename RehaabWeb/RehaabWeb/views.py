
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
from django.contrib.auth.forms import SetPasswordForm
from django.contrib import messages
from django.utils.http import urlsafe_base64_decode
from django.utils.crypto import get_random_string
from django.utils.encoding import force_bytes
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

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

import random
import string

def generate_random_password(length=8, include_uppercase=True, include_lowercase=True, include_digits=True, include_special_chars=True):
    
    characters = ''
    if include_uppercase:
        characters += string.ascii_uppercase
    if include_lowercase:
        characters += string.ascii_lowercase
    if include_digits:
        characters += string.digits
    if include_special_chars:
        characters += string.punctuation

    characters = list(set(characters))

  

    random.shuffle(characters)
    password = ''.join(characters[:length])
    return password

def send_email(passw,emails):
    from django.core.mail import EmailMessage

    import smtplib

    smtpserver = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    smtpserver.ehlo()
    smtpserver.login('rehaabsystem@gmail.com', 'krmmzlnywthfqepa')
    sent_from = 'rehaabsystem@gmail.com'
    sent_to = emails  
    email_text = f'Your account created with email {emails} and your password is "{passw}" \n Thank You'
    smtpserver.sendmail(sent_from, sent_to, email_text)


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
                    passw=generate_random_password()
                    hashed_password = make_password(passw) 
                    hashed_password = hashed_password[7:]
                    send_email(passw,email)
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


     latitude_values = [marker['Latitude'] for marker in AllSupport if marker['Solved'] == 0] 
     longitude_values = [marker['Longitude'] for marker in AllSupport if marker['Solved'] == 0]
     message = ''.join(str(marker['supportID']) for marker in AllSupport if marker['Solved'] == 0)


     data = {'AllSupport':list(AllSupportWithUser),'Active': active_reservations,'support_count':support_count,'s_support_count':us_support_count,'num_of_backup_vehicles':num_of_backup_vehicles,'latitude_values':latitude_values,'longitude_values':longitude_values,'message':message,'Sudden':sudden_stop_count,'Empty':empty_battery_count,'other':other_count,'Double':Double,'Single':Single}
     return JsonResponse(data)



def reset_password(request):

    import smtplib
    if request.method == 'POST':
        email = request.POST['email']
        try:
            user = User.objects.get(Email=email)
        except User.DoesNotExist:
            user = None

        if user is not None:
            uid = user.userID
            reset_url = request.build_absolute_uri(
                f'/reset_password_confirm.html/{uid}/'
            )
            sender_email = 'rehaabsystem@gmail.com'
            receiver_email = email
            subject = 'Reset Your Password'
            link = reset_url
            message =   f'<h2> Hello, </h2> <h3> <p> A request has been received to reset the password for your Rehaab account, please click this link to reset your password</p></h3>\n<p> <a href= "{link}"> Reset Password</a></p>\n  <h3> if you did not initate this request, just ignore this email.<h3><h3>Thank you,<br> Rehaab team. </h3>'

            msg = MIMEMultipart()
            msg['From'] = sender_email
            msg['To'] = receiver_email
            msg['Subject'] = subject

            msg.attach(MIMEText(message, 'html'))
            
        
            smtp_server = 'smtp.gmail.com'
            smtp_port = 587
            smtp_username = 'rehaabsystem@gmail.com'
            smtp_password = 'krmmzlnywthfqepa'
            server = smtplib.SMTP(smtp_server, smtp_port)
            server.starttls()
            server.login(smtp_username, smtp_password)

            server.send_message(msg)

            server.quit()



        return redirect('reset_password_done')

    return render(request, 'reset_password.html')

def reset_password_done(request):
    return render(request, 'reset_password_done.html')

def reset_password_confirm(request, uidb64):
    try:
        user = User.objects.get(userID=uidb64)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist):
        user = None

    if user is not None:
        if request.method == 'POST':
                NPass = request.POST['Npass']
                CPass = request.POST['Cpass']
                if NPass == CPass:
                    hashed_password = make_password(NPass)
                    try:
                        user = User.objects.get(userID=uidb64)
                        user.Password = hashed_password
                        user.save()
                    except User.DoesNotExist:
                
                     messages.success(request, 'Your password has been successfully reset. You can now log in with your new password.')
                    return redirect('reset_password_complete')
                else:
                  messages.error(request, "Passwords do not match.")  
                return redirect(f'/reset_password_confirm.html/{uidb64}/')
          
        else:
            form = SetPasswordForm(user)

        return render(request, 'reset_password_confirm.html', {'form': form})

    return redirect('sign-in')

def reset_password_complete(request):
    return render(request, 'reset_password_complete.html')

