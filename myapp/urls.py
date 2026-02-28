"""
URL configuration for careerpath project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
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
from django.urls import path

from myapp import views

urlpatterns = [
    path('login_get/',views.login_get),
    path('guide_home/',views.guide_home),
    path('admin_add_exam/',views.admin_add_exam),
    path('add_exam_post/',views.add_exam_post),
    path('admin_home/',views.admin_home),
    path('admin_admin_login/',views.admin_admin_login),
    path('admin_change_password/',views.admin_change_password),
    path('change_password_post/', views.change_password_post),

    path('admin_send_reply/<id>',views.admin_send_reply),
    path('admin_send_reply_post/',views.admin_send_reply_post),
    path('admin_verify_company/', views.admin_verify_company),
    path('AcceptCompany/<id>/', views.AcceptCompany),
    path('RejectCompany/<id>/', views.RejectCompany),

    path('admin_verify_guide/', views.admin_verify_guide),
    path('Acceptguide/<id>/', views.Acceptguide),
    path('Rejectguide/<id>/', views.Rejectguide),

    path('admin_view_company/', views.admin_view_company),
    path('admin_view_company_feedback/', views.admin_view_company_feedback),
    path('admin_view_complaints/', views.admin_view_complaints),
    path('admin_view_exam/', views.admin_view_exam),
    path('admin_delete_exam/<id>', views.admin_delete_exam),
    path('admin_view_guide/', views.admin_view_guide),
    path('admin_view_users/', views.admin_view_users),
    path('admin_appfeedback/',views.admin_appfeedback),
    ###################################company#########################################################################
    path('company_add_vaccancy/',views.company_add_vaccancy),
    path('add_vaccancy_post',views.add_vaccancy_post),
    path('delete_vaccancy/<id>',views.delete_vaccancy),

    path('company_change_password/',views.company_change_password),
    path('gchange_password_post/',views.gchange_password_post),
    path('company_company_home/',views.company_company_home),
    path('company_company_registraion/',views.company_company_registraion),
    path('company_registraion_post/',views.company_registraion_post),
    path('company_interviews_schedule/<id>/',views.company_interviews_schedule),
    path('interviews_schedule_post/',views.interviews_schedule_post),
    path('company_view_application/',views.company_view_application),
    path('company_view_review/',views.company_view_review),
    path('company_view_vacancy/',views.company_view_vacancy),
    path('manageprofile',views.manageprofile),
    path('manageprofile_post',views.manageprofile_post),
    path('acceptappliication/<id>/',views.acceptappliication),
    path('rejectappliication/<id>/',views.rejectappliication),
    ####################################guide########################################################################
    path('guide_add_questionpp/', views.guide_add_questionpp),
    path('deletetips/<id>', views.deletetips),
    path('guide_add_tips/', views.guide_add_tips),
    path('add_tips_post', views.add_tips_post),

    path('guide_add_video/', views.guide_add_video),
    path('add_video_post', views.add_video_post),


    path('guide_change_password/', views.guide_change_password),
    path('change_password_post/', views.change_password_post),

    path('guide_guide_home_/', views.guide_guide_home_),
    path('guide_index/', views.guide_index),

    path('guide_guide_register/', views.guide_guide_register),
    path('guide_register_post/', views.guide_register_post),

    path('guide_manage_questionpp/', views.guide_manage_questionpp),
    path('add_questionpp_post', views.add_questionpp_post),
    path('delete_questionpp/<id>', views.delete_questionpp),
    
    path('guide_review_/', views.guide_review_),
    path('user_viewchat/', views.user_viewchat),


    path('guide_user_request/', views.guide_user_request),
    path('Acceptuser/<id>/', views.Acceptuser),
    path('Rejectuser/<id>/', views.Rejectuser),



    path('guide_view_tips/', views.guide_view_tips),
    path('guide_view_video', views.guide_view_video),
    path('viewprofileguide', views.viewprofileguide),
    path('update_profile/', views.update_profile),
    path('updateprofile_post/', views.updateprofile_post),
    path('delete_video/<id>', views.delete_video),



    ########################################
    path('/flut_view_application/', views.flut_view_application),
    path('flut_view_profile/', views.flut_view_profile),
    path('flut_upload_resume/', views.flut_upload_resume),
    path('flut_view_vaccancies/', views.flut_view_vaccancies),
    path('flut_apply_vacancy/', views.flut_apply_vacancy),
    path('flut_send_application/', views.flut_send_application),
    path('flut_view_application_status/', views.flut_view_application_status),
    path('flut_view_interview_details/', views.flut_view_interview_details),
    path('/flut_send_request/', views.flut_send_request),
    path('flut_view_request_status/', views.flut_view_request_status),
    path('flut_send_g_rating/', views.flut_send_g_rating),
    path('/flut_view_interviewtips/', views.flut_view_interviewtips),
    path('flut_view_motivideo/', views.flut_view_motivideo),
    path('flut_view_previusqp/', views.flut_view_previusqp),
    # path('flut_send_complaint/', views.flut_send_complaint),
    # path('flut_view_reply/', views.flut_view_reply),
    path('flut_send_c_review/', views.flut_send_c_review),
    path('flut_view_c_review/', views.flut_view_c_review),
    path('flut_send_appfeedback/', views.flut_send_appfeedback),
    path('flut_changepassword/', views.flut_changepassword),
    path('flut_chat/', views.flut_chat),
    path('flut_UserRegistration/', views.flut_UserRegistration),
    path('and_login/', views.and_login),
    path('flut_view_company/', views.flut_view_company),
    path('/flut_view_guide/', views.flut_view_guide),
    path('viewreply', views.viewreply),
    path('complaintadd',views.complaintadd),
    path('viewfeedback',views.viewfeedback),
    path('feedbackadd',views.feedbackadd),
    path('/flut_send_application/',views.flut_send_application),
    path('flut_view_exam/',views.flut_view_exam),
    path('/forgotpasswordflutter/',views.forgotpasswordflutter),
    path('/verifyOtpflutterPost/',views.verifyOtpflutterPost),
    path('/changePasswordflutter/',views.changePasswordflutter),
    path('forget_passwordweb/',views.forget_passwordweb),
    path('forgetpassword_otp/',views.forgetpassword_otp),
    path('verifyotp/',views.verifyotp),
    path('verifyotp_post/',views.verifyotp_post),
    path('newpassword/',views.newpassword),





]
