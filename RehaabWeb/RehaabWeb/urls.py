"""
URL configuration for RehaabWeb project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from . import views
from django.urls import reverse

urlpatterns = [
    path('admin/', admin.site.urls),
    path('index.html/', views.index, name='index'),
    path('', views.signin, name='sign-in'),
    path('UpdateParameters.html/', views.UpdateParameters, name='UpdateParameters'),
    path('AssignVM.html/', views.AssignVM, name='AssignVM'),
    path('CreateAdmin.html/', views.create_user, name='CreateAdmin'),
    path('ajax/get_Vehicles_Info/', views.get_Vehicles_Info, name='get_Vehicles_Info'),
    path('ForgetPass.html/', views.ForgetPass, name='ForgetPass'),
    path('deleteVM/<int:id>/', views.deleteVM, name="deleteVM"),
    path('delete_support/', views.delete_Support, name='delete_Support'),
    

]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
