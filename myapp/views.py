import datetime
import random

from django.conf import settings
from django.contrib import messages
from django.contrib.auth import authenticate, login, update_session_auth_hash
from django.contrib.auth.hashers import make_password, check_password
from django.core.files.storage.filesystem import FileSystemStorage
from django.core.mail import send_mail
from django.db.models.query_utils import Q
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.contrib.auth.models import User,Group

# Create your views here.
from django.views.decorators.csrf import csrf_exempt

from myapp.models import *


@csrf_exempt
def login_get(request):
    if request.method=="POST":
        print(request.POST)
        username=request.POST["username"]
        password=request.POST["password"]
        ob=authenticate(request,username=username,password=password)
        print(ob,"hhhhhhhhhhhhhhh")
        if ob is not None:
           if ob.groups.filter(name="Admin").exists():
              login (request,ob)
              return redirect('/myapp/admin_home/')
           elif ob.groups.filter(name="guide").exists():
               k = guide.objects.get(status='guide',LOGIN__id=ob.id)
               if k is not None:
                     login(request,ob)
                     return redirect('/myapp/guide_home')
           elif ob.groups.filter(name="company").exists():
               print(ob.id,"aaaaaaaaaaaaaaaa")
               k=company_table.objects.filter(status='Accepted',LOGIN_id=ob.id)
               if k is not None:
                 login(request,ob)
                 return redirect('/myapp/company_company_home/')
        else:
          return redirect('/myapp/login_get/')
    return render(request,'admin/adminlogin.html')

#===========================================================ADMIN

def admin_home(request):
    return render(request,'admin/admin_home new.html')

def admin_add_exam(request):
    return render(request,'admin/addexam.html')

def add_exam_post(request):
    name=request.POST['name']
    details = request.POST['details']
    date =request.POST['date']
    link = request.POST['link']

    ob=exam_info()
    ob.exam_name=name
    ob.details=details
    ob.last_date=date
    ob.link=link
    ob.save()
    return redirect('/myapp/admin_view_exam/')

def admin_admin_login(request):
    return render(request,'admin/adminlogin.html')


def admin_change_password(request):
    return render(request,'admin/changepassword.html')

def change_password_post(request):
    current_password = request.POST['current_password']
    new_password = request.POST['new_password']
    confirm_password = request.POST['confirm_password']
    user = User.objects.get(id=request.user.id)
    print(user)
    if user.check_password(current_password):
        if new_password == confirm_password:
            user.set_password(new_password)
            user.save()
            update_session_auth_hash(request, user)
            messages.success(request, "your password was successfully updated!")
            return redirect('/myapp/login_get/')
        else:
            messages.error(request, "new password do not match.")
            return redirect('/myapp/admin_change_password/')
    else:
        messages.error (request, "current password is incorrect.")
        return redirect('/myapp/admin_change_password/')

def admin_view_exam(request):
    ob=exam_info.objects.all()
    return render(request,'admin/viewexam.html',{"data":ob})
def admin_delete_exam(request,id):
    ob=exam_info.objects.get(id=id)
    ob.delete()
    return redirect('/myapp/admin_view_exam/')


def admin_send_reply(request,id):
    request.session['cid']=id
    return render(request,'admin/sendreply.html')


def admin_send_reply_post(request):
    repl=request.POST['reply']
    ob=complaint.objects.get(id=request.session['cid'])
    ob.reply=repl
    ob.save()
    return redirect('/myapp/admin_view_complaints/')


def admin_verify_company(request):
    ob=company_table.objects.all()
    return render(request,'admin/verifycompany.html',{"data":ob})

def AcceptCompany(request,id):
    ob=company_table.objects.get(id=id)
    ob.status='company'
    ob.save()
    return redirect('/myapp/admin_verify_company/')

def RejectCompany(request,id):
    ob=company_table.objects.get(id=id)
    ob.status='Rejected'
    ob.save()
    return redirect('/myapp/admin_verify_company/')

def admin_verify_guide(request):
    ob=guide.objects.all()
    return render(request,'admin/verifyguide.html',{"data":ob})

def Acceptguide(request,id):
    ob=guide.objects.get(id=id)
    ob.status='guide'
    ob.save()
    return redirect('/myapp/admin_verify_guide/')

def Rejectguide(request,id):
    ob=guide.objects.get(id=id)
    ob.status='Rejected'
    ob.save()
    return redirect('/myapp/admin_verify_guide/')


def admin_view_company(request):
    return render(request,'admin/viewcompany.html')
def admin_view_company_feedback(request):
    ob=company_review.objects.all()
    l=[1,2,3,4,5]
    return render(request,'admin/viewcompanyfeedback.html',{"data":ob,"l":l})
def admin_view_complaints(request):
    ob=complaint.objects.all()
    return render(request,'admin/viewcomplaints.html',{"data":ob})

def admin_view_guide(request):
    ob=guide_review.objects.all()
    return render(request,'admin/viewguidefeedback.html',{"data":ob})



def admin_view_users(request):
    ob=user_table.objects.all()
    return render(request,'admin/viewusers.html',{"applicants":ob})

def admin_appfeedback(request):
    ob=app_feedback.objects.all()
    l = [1, 2, 3, 4, 5]
    return render(redirect,'admin/appfeedback.html',{'data':ob,"l":l})



###################################company############################
def company_add_vaccancy(request):
    return render(request,'company/addvaccancy.html')
def add_vaccancy_post(request):
    vaccancys = request.POST['vacancy']
    details = request.POST['details']
    salary = request.POST['salary']
    experience = request.POST['experience']
    qualification = request.POST['qualification']
    requirements = request.POST['requirements']
    no_of_vaccancy = request.POST['no_of_vaccancy']
    date = request.POST['date']
    ob=vaccancy()
    ob.vaccancy=vaccancys
    ob.details=details
    ob.salary=salary
    ob.experience=experience
    ob.qualification=qualification
    ob.requirement=requirements
    ob.no_of_vaccancy=no_of_vaccancy
    ob.date=date
    ob.COMPANY=company_table.objects.get(LOGIN=request.user.id)
    ob.save()
    return render (request,'company/companyhome.html')



def delete_vaccancy(request,id):
    ob =vaccancy.objects.get(id=id)
    ob.delete()
    return redirect ('/myapp/company_view_vacancy/')





def company_change_password(request):
    return render(request,'company/c_changepassword.html')
def gchange_password_post(request):
        current_password = request.POST['current_password']
        new_password = request.POST['new_password']
        confirm_password = request.POST['confirm_password']
        user = User.objects.get(id=request.user.id)
        print(user)
        if user.check_password(current_password):
            if new_password == confirm_password:
                user.set_password(new_password)
                user.save()
                update_session_auth_hash(request, user)
                messages.success(request, "your password was successfully updated!")
                return redirect('/myapp/login_get/')
            else:
                messages.error(request, "new password do not match.")
                return redirect('/myapp/company_change_password/')
        else:
            messages.error(request, "current password is incorrect.")
            return redirect('/myapp/company_change_password//')
        return render(request,'company/c_changepassword.html')


def company_company_home(request):
    return render(request,'company/companyhome.html')


def company_company_registraion(request):
    return render(request,'company/companyregistration.html')

def company_registraion_post(request):
    name = request.POST['name']
    email = request.POST['email']
    phone  = request.POST['phone']
    since = request.POST['since']
    place  = request.POST['place']
    pincode = request.POST['pincode']
    district  = request.POST['district']
    state = request.POST['state']
    photo  = request.FILES['photo']
    proof = request.FILES['proof']
    user_name = request.POST['username']
    password = request.POST['password']
    user=User.objects.create(username=user_name,password=make_password(password))
    user.save()
    user.groups.add(Group.objects.get(name='company'))
    ob=company_table()
    ob.name = name
    ob.email=email
    ob.phone=phone
    ob.since=since
    ob.place=place
    ob.pincode=pincode
    ob.district=district
    ob.state=state
    ob.photo=photo
    ob.proof=proof
    ob.LOGIN=user
    ob.save()
    return redirect('/myapp/login_get/')



def company_interviews_schedule(request,id):
    request.session['apid']=id
    return render(request,'company/interviewschedule.html')

def interviews_schedule_post(request):
    date = request.POST['date']
    appliccation.objects.filter(id=request.session['apid']).update(interview_date=date,status="scheduled")
    return redirect('/myapp/company_view_application/')



def company_view_application(request):
    data = appliccation.objects.filter(VACCANCY__COMPANY__LOGIN_id=request.user.id)
    return render(request, 'company/viewapplication.html', {"data": data})

def acceptappliication(request,id):
    ob = appliccation.objects.get(id=id)
    ob.status = 'Accept'
    ob.save()
    return redirect('/myapp/company_view_application/',{"data":ob})
def rejectappliication(request,id):
    ob = appliccation.objects.get(id=id)
    ob.status = 'Reject'
    ob.save()
    return redirect('/myapp/company_view_application/',{"data":ob})

def company_view_review(request):
    data=company_review.objects.all()
    return render(request,'company/viewreview.html',{"data":data})

def company_view_vacancy(request):
    ob=vaccancy.objects.filter(COMPANY__LOGIN__id=request.user.id)
    return render(request,'company/viewvacancy.html',{"data":ob})

def manageprofile(request):
    ob=company_table.objects.get(LOGIN__id=request.user.id)
    return render(request,'company/manageprofile.html',{"val":ob})

def manageprofile_post(request):
    name = request.POST['name']
    email = request.POST['email']
    phone = request.POST['phone']
    since = request.POST['since']
    place = request.POST['place']
    pincode = request.POST['pincode']
    district = request.POST['district']
    latitude = request.POST['latitude']
    longitude = request.POST['longitude']
    state = request.POST['state']
    photo = request.FILES.get('photo')
    proof = request.FILES.get('proof')
    status = request.POST['status']


    ob = company_table.objects.get(LOGIN__id=request.user.id)
    ob.name=name
    ob.email=email
    ob.phone=phone
    ob.since=since
    ob.place=place
    ob.pincode=pincode
    ob.district=district
    ob.latitude=latitude
    ob.longitude=longitude
    if photo:
        ob.photo=photo
    if proof:
        ob.proof=proof
    ob.status=status
    ob.state=state
    ob.save()
    return render(request,'company/companyhome.html')





##################################guide##########################################




def guide_home(request):
    return render(request,'guide/index.html')



def guide_add_questionpp(request):
    ob=exam_info.objects.all()
    return render(request,'guide/addquestionpp.html',{"val":ob})

def delete_questionpp(request,id):
    ob=qustionpaper.objects.get(id=id)
    ob.delete()
    return redirect('/myapp/guide_manage_questionpp/')
def add_questionpp_post(request):
    question_paper = request.FILES['question_paper']
    answer=request.FILES['answer']
    year=request.POST['year']
    exam=request.POST['exam']
    ob=qustionpaper()
    ob.qustionpaper=question_paper
    ob.answersheet=answer
    ob.year=year
    ob.GUIDE=guide.objects.get(LOGIN__id=request.user.id)
    ob.EXAM=exam_info.objects.get(id=exam)
    ob.save()
    return redirect('/myapp/guide_manage_questionpp')

def guide_add_tips(request):
    return render(request,'guide/addtips.html')


def deletetips(request,id):
    ob=tips.objects.get(id=id)
    ob.delete()
    return redirect('/myapp/guide_view_tips/')


def add_tips_post(request):
    tip = request.POST['tip']
    description = request.POST['description']
    ob=tips()
    ob.GUIDE=guide.objects.get(LOGIN__id=request.user.id)
    ob.tips=tip
    ob.discriptio=description
    ob.date=datetime.datetime.today()
    ob.save()
    return redirect('/myapp/guide_view_tips')

def guide_add_video(request):
    return render(request,'guide/addvedio.html')

def add_video_post(request):
    title=request.POST['title']
    video=request.FILES['video']
    date=datetime.datetime.today()
    ob=videos()
    ob.GUIDE=guide.objects.get(LOGIN__id=request.user.id)
    ob.title=title
    ob.vedios=video
    ob.date=date
    ob.save()
    return redirect('/myapp/guide_view_video')

def delete_video(request,id):
    ob = videos.objects.get(id=id)
    ob.delete()
    return redirect('/myapp/guide_view_video')

def guide_change_password(request):
    return render(request,'guide/g_changepassword.html')


def guide_guide_home_(request):
    return render(request,'guide/index.html')

def guide_guide_register(request):
    return render(request,'guide/guideregister.html')
def guide_register_post(request):
    name = request.POST['name']
    gender=request.POST['gender']
    DOB = request.POST['DOB']
    phone = request.POST['phone']
    email = request.POST['email']
    qualification = request.POST['qualification']
    experience = request.POST['experience']
    user_name = request.POST['username']
    password = request.POST['password']
    user=User.objects.create(username=user_name,password=make_password(password),email=email,first_name=name)
    user.save()
    user.groups.add(Group.objects.get(name="Guide"))
    ob=guide()
    ob.LOGIN=user
    ob.name=name
    ob.gender=gender
    ob.DOB=DOB
    ob.phone=phone
    ob.email=email
    ob.qualifiication=qualification
    ob.experience=experience
    ob.status="pending"
    ob.save()

    return redirect("/myapp/login_get")




def guide_manage_questionpp(request):
    ob=qustionpaper.objects.all()
    return render(request,'guide/managequstionpp.html',{"val":ob})

def guide_index(request):
    return render(request,'guide/index.html')

def guide_review_(request):
    ob=guide_review.objects.all()
    return render(request,'guide/review.html',{"data":ob})

def guide_user_request(request):
    ob=user_request.objects.all()
    return render(request,'guide/userrequest.html',{'data':ob})

def guide_view_tips(request):
    ob=tips.objects.filter(GUIDE__LOGIN__id=request.user.id)
    return render(request,'guide/viewtips.html',{"val":ob})

def guide_view_user(request):
    return render(request,'guide/viewuser.html')

def guide_view_video(request):
    ob=videos.objects.all()
    return render(request,'guide/viewvedio.html',{"data":ob})


def viewprofileguide(request):
    ob=guide.objects.get(LOGIN__id=request.user.id)
    return render(request,'guide/view profile.html',{"guide":ob})




def update_profile(request):
    ob=guide.objects.get(LOGIN__id=request.user.id)
    return render(request,'guide/update profile.html',{"guide":ob,"date":str(ob.DOB)})

def updateprofile_post(request):
    name=request.POST['name']
    gender=request.POST['gender']
    DOB=request.POST['DOB']
    phone=request.POST['phone']
    email=request.POST['email']
    experience=request.POST['experience']
    qualification=request.POST['qualification']
    ob=guide.objects.get(LOGIN__id=request.user.id)
    ob.name=name
    ob.gender=gender
    ob.DOB=DOB
    ob.phone=phone
    ob.email=email
    ob.experience=experience
    ob.qualification=qualification
    ob.save()
    return redirect("/myapp/viewprofileguide")

def Acceptuser(request,id):
    ob=user_request.objects.get(id=id)
    ob.status='Accept'
    ob.save()
    return redirect('/myapp/guide_user_request/')

def Rejectuser(request,id):
    ob=user_request.objects.get(id=id)
    ob.status='Rejected'
    ob.save()
    return redirect('/myapp/guide_user_request/')



############### flutter ############################

def flut_UserRegistration(request):
    print(request.POST,"llllllllllllllllllllll")
    username=request.POST['username']
    password=request.POST['password']
    name=request.POST['name']
    email=request.POST['email']
    phone=request.POST['phone']
    dob=request.POST['dob']
    since=request.POST['since']
    gender=request.POST['gender']
    place=request.POST['place']
    pincode=request.POST['pin']
    district=request.POST['district']
    state=request.POST['state']
    photo=request.FILES['photo']
    resume=request.FILES['resume']

    user=User.objects.create_user(username=username,password=password)
    user.save()
    user.groups.add(Group.objects.get(name='User'))

    ob=user_table()
    ob.username = username
    ob.password = password
    ob.name = name
    ob.email = email
    ob.phone = phone
    ob.dob = dob
    ob.since = since
    ob.gender = gender
    ob.place = place
    ob.pincode = pincode
    ob.district = district
    ob.state = state
    ob.photo = photo
    ob.LOGIN=user
    ob.resume = resume
    ob.save()
    return JsonResponse({"status":"ok"})





def flut_view_profile(request):
    return JsonResponse({'status':'ok'})

def flut_view_vaccancies(request):
    cid=request.POST['cid']
    vacancies = vaccancy.objects.filter(COMPANY_id=cid)
    data = []

    for i in vacancies:
        data.append({
            'id': str(i.id),
            'vaccancy': str(i.vaccancy),
            'details': str(i.details),
            'salary': str(i.salary),
            'experience': str(i.experience),   # FIXED
            'qualification': str(i.qualification),
            'requirement': str(i.requirement),
            'date': str(i.date),
            'no_of_vaccancy': str(i.no_of_vaccancy),
        })

    return JsonResponse({'status': 'ok', 'data': data})

def flut_view_application(request):
    lid=request.POST['lid']
    l=[]
    a=appliccation.objects.filter(USER__LOGIN_id=lid)
    for i in a:
        l.append({
            'date':str(i.date),
            'score':str(i.score),
            'status':str(i.status),
            'interview_date':str(i.interview_date),
            'vacancy':str(i.VACCANCY.vaccancy),
        })
    return JsonResponse({'status':'ok','data':l})

def flut_apply_vacancy(request):
    return JsonResponse({'status':'ok'})
from .pdf_read import maincode,maincode_dsim
def flut_upload_resume(request):
    print(request.FILES)
    file=request.FILES['resume']
    fs=FileSystemStorage()
    fn=fs.save(file.name,file)
    sorted_results=maincode(r"C:\Users\U\PycharmProjects\careerpath\media/"+fn)
    print(sorted_results,"kkkkkkkkkkkkkk")
    lis=[]
    print("\nResults sorted by similarity (descending):")
    for category, similarity_score in sorted_results:
        print("Category: {category}, Similarity: {similarity_score:.4f}")
        lis.append({"cat":category,"sim":str(round(similarity_score,4))})
        print(lis,"jhhhhhhhhhhhhhhhhhhhhh")
    return JsonResponse({'status':'ok',"data":lis})

def flut_view_application_status(request):
    l = []
    a = user_request.objects.all()
    for i in a:
        l.append({
            'User': str(i.USER.name),
            'guide': str(i.GUIDE.name),
            'request': str(i.request),
            'date': str(i.date),
            'status': str(i.status),

        })
    return JsonResponse({'status':'ok'})

def flut_view_interview_details(request):
    return JsonResponse({'status':'ok'})

def flut_send_request(request):
    gid = request.POST['guide_id']
    uid = request.POST['lid']
    request = request.POST['request_message']

    ob=user_request()
    ob.request=request
    ob.status="pending"
    ob.date=datetime.datetime.today()
    ob.USER = user_table.objects.get(LOGIN_id=uid)
    ob.GUIDE = guide.objects.get(id=gid)
    ob.save()
    return JsonResponse({'status':'ok'})


def flut_send_application(request):
    print(request.POST,"kkkkkkkkkkkkkkkk")
    # fileName=request.FILES['fileName']
    vid=request.POST['vid']
    obv=vaccancy.objects.get(id=vid)
    details=obv.details+" "+obv.experience+" "+obv.qualification+" "+obv.requirement
    lid=request.POST['lid']
    file = request.FILES['fileName']
    fs = FileSystemStorage()
    fn = fs.save(file.name, file)
    sorted_results = maincode_dsim(r"C:\Users\U\PycharmProjects\careerpath\media/" + fn,details)

    # v=vaccancy.objects.get(id=vid)

    ob=appliccation()
    ob.VACCANCY=vaccancy.objects.get(id=vid)
    ob.USER=user_table.objects.get(LOGIN__id=lid)
    ob.date=datetime.datetime.today()
    # ob.interview_date=datetime.datetime.today()
    ob.score=sorted_results
    ob.status="pending"
    ob.Resume=fn
    ob.save()
    return JsonResponse({'status': 'ok'})








def flut_view_request_status(request):
    l = []
    a = user_request.objects.all()
    for i in a:
        l.append({
            'request': str(i.request),
            'date': str(i.date),
            'status': str(i.status),
            'guide': str(i.GUIDE.name),
            'user': str(i.USER.name),

        })
    return JsonResponse({'status': 'ok', 'data': l})


def flut_send_g_rating(request):
    print(request.POST)
    review = request.POST['review']
    rating = request.POST['rating']
    # data = request.POST['data']
    gid=request.POST['gid']
    uid=request.POST['uid']
    ob=guide_review()
    ob.review=review
    ob.date=datetime.datetime.today()
    ob.rating=rating
    ob.data='pending'
    ob.USER = user_table.objects.get(LOGIN_id=uid)
    ob.GUIDE =guide.objects.get(id=gid)
    ob.save()
    return JsonResponse({'status': 'ok'})

def flut_view_interviewtips(request):
    l = []
    a = tips.objects.all()
    for i in a:
        l.append({
            'tips': str(i.tips),
            'discriptio': str(i.discriptio),
            'date': str(i.date),
            'guide': str(i.GUIDE.name),
        })
    return JsonResponse({'status':'ok','data':l})

def flut_view_motivideo(request):
    l = []
    a = videos.objects.all()
    for i in a:
        l.append({
            'id': str(i.id),
            'title': str(i.title),
            'videos': str(i.vedios.url),
            'date': str(i.date),
            'guide': str(i.GUIDE.name),
        })
    print(l)
    return JsonResponse({'status':'ok','data':l})

def flut_view_previusqp(request):
    l = []
    a = qustionpaper.objects.all()
    for i in a:
        l.append({
            'qustionpaper': str(i.qustionpaper),
            'qid': str(i.id),
            'answersheet': str(i.answersheet),
            'year': str(i.year),
            'guide': str(i.GUIDE.name),
            'exam': str(i.EXAM.exam_name),
        })
    return JsonResponse({'status':'ok','data':l})

def complaintadd(request):
    date = datetime.datetime.today()
    complaints = request.POST['complaint']
    lid = request.POST['lid']
    ob=complaint()
    ob.USER=user_table.objects.get(LOGIN__id=lid)
    ob.date=date
    ob.complaint=complaints
    ob.reply='pending'
    ob.save()
    return JsonResponse({'task': 'ok'})
def feedbackadd(request):
    date = datetime.datetime.today()
    complaints = request.POST['feedback']
    rat = request.POST['rating']
    lid = request.POST['lid']
    ob=app_feedback()
    ob.USER=user_table.objects.get(LOGIN__id=lid)
    ob.date=date
    ob.rating=rat
    ob.feedback=complaints
    ob.status='pending'
    ob.save()
    return JsonResponse({'task': 'ok'})


def viewreply(request):
    lid=request.POST['lid']
    l = []
    a = complaint.objects.filter(USER__LOGIN__id=lid)
    for i in a:
        l.append({
            'complaint': str(i.complaint),
            'reply': str(i.reply),
            'date': str(i.date),
            "id":i.id
        })
    return JsonResponse({'status':'ok','data':l})

def viewfeedback(request):
    lid=request.POST['lid']
    l = []
    a = app_feedback.objects.filter(USER__LOGIN__id=lid)
    for i in a:
        l.append({
            'feedback': str(i.feedback),
            'reply': str(i.rating),
            'date': str(i.date),
            "id":i.id
        })
    return JsonResponse({'status':'ok','data':l})

def flut_send_c_review(request):
    lid = request.POST['lid']
    cid = request.POST['cid']
    print(cid)
    review = request.POST["review"]
    rating = request.POST["rating"]
    date = datetime.datetime.today()

    obj = company_review()
    obj.review = review
    obj.rating= rating
    obj.USER = user_table.objects.get(LOGIN_id=lid)
    obj.date = date
    obj.COMPANY = company_table.objects.get(id=cid)
    obj.save()
    return JsonResponse({'status': 'ok', })




def flut_view_c_review(request):
    l = []

    a = company_review.objects.all()
    for i in a:
        l.append({
            'date': str(i.date),
            'review': str(i.review),
            'rating': str(i.rating),

        })
    return JsonResponse({'status':'ok','data':l})


def flut_send_appfeedback(request):
    date = request.POST['date']
    feedback = request.POST['feedback']
    status = request.POST['status']
    rating = request.POST['rating']
    ob = user_table.objects.get(LOGIN__id=request.user.id)
    ob=user_request()
    ob.feedback = feedback
    ob.date = date
    ob.status = status
    ob.rating = rating
    ob.save()
    return


def flut_changepassword(request):
    return JsonResponse({'status':'ok'})

def flut_chat(request):
    from_id = request.POST['from_id']
    to_id = request.POST['to_id']
    message = request.POST['message']
    date = request.POST['date']
    status = request.POST['status']
    ob=chat()
    ob.from_id = from_id
    ob.to_id = to_id
    ob.status = 'pending'
    ob.message = message
    ob.date=date
    ob.save()
    return JsonResponse({'status':"ok"})

def user_viewchat(request):
    fromid = request.POST["from_id"]
    toid = request.POST["to_id"]
    # lmid = request.POST["lastmsgid"]    from django.db.models import Q

    res = chat.objects.filter(Q(from_id=fromid, to_id=toid) | Q(from_id=toid, to_id=fromid)).order_by("id")
    l = []

    for i in res:
        l.append({"id": i.id, "msg": i.message, "from": i.from_id, "date": i.date, "to": i.to_id})

    return JsonResponse({"status":"ok",'data':l})






# def flut_view_company(request):
#     l = []
#     a = company_table.objects.filter(status='company')
#     for i in a:
#
#         print(l)
#         l.append({
#             # 'cid':i.cid,
#             'name': str(i.name),
#             'email': str(i.email),
#             'phone': str(i.phone),
#             'place': str(i.place),
#             'since':str(i.since),
#             'pincode': str(i.pincode),
#             'district': str(i.district),
#             'latitude': str(i.latitude),
#             'longitude': str(i.longitude),
#             'photo': str(i.photo),
#             'proof': str(i.proof),
#             'status': str(i.status),
#             'state': str(i.state),
#
#         })
#     return JsonResponse({'status':'ok','data':l})
#



def flut_view_company(request):
    companies = company_table.objects.filter(status='company')
    l = []

    for i in companies:
        l.append({
            # 'cid': str(i.cid),
            'id': i.id,
            'name': i.name,
            'email': i.email,
            'phone': i.phone,
            'place': i.place,
            'since': i.since,
            'pincode': i.pincode,
            'district': i.district,
            'latitude': i.latitude,
            'longitude': i.longitude,
            'photo': i.photo.url,
            'proof': str(i.proof),
            'status': i.status,
            'state': i.state,
        })
        print(l,"kkkkkkkkk")
    return JsonResponse({'status': 'ok', 'data': l})


def flut_view_guide(request):
    guides = guide.objects.filter(status='guide')
    l = []

    for i in guides:
        l.append({
            'id': i.id,
            'name': i.name,
            'gender': i.gender,
            'email': i.email,
            'phone': i.phone,
            'place': str(i.DOB),
            'qualifiication': i.qualifiication,
            'experience': i.experience,
        })
        print(l,"kkkkkkkkk")
    return JsonResponse({'status': 'ok', 'data': l})
def flut_view_exam(request):
    l = []
    a=exam_info.objects.all()
    for i in a :
        l.append({
            'cid': i.id,
            'exam_name': i.exam_name,
            'details': i.details,
            'last_date': i.last_date,
            'link': i.link,
        })
        print(l,"kkkkkkkkk")
    return JsonResponse({'status': 'ok', 'data': l})

#####################################################################################################
def and_login (request):
    username = request.POST['username']
    password = request.POST['password']
    if not username or not password:
        return JsonResponse({"status":"no"})
    user = authenticate(request, username=username, password=password)
    if user is not None:
        if user.groups.filter(name="User").exists():
            ob=user_table.objects.get(LOGIN_id=user.id)
            login(request,user)
            return JsonResponse({"status":"ok","lid":user.id,"type":"User",'photo':str(ob.photo.url),'name':str(ob.name),'email':str(ob.email)})
    else:
        return JsonResponse({"status":"ok"})

#############################forgotpassword###################################################
# def ForgotPassword(request):
#     return render(request,'forgot_password.html')
#
# def forgotPassword_otp(request):
#     if 'email' in request.POST:
#         request.session['email']= request.POST['email']
#     email=request.session['email']
#     try:
#         user=User.objects.get(email=email)
#     except User.DoesNotExist:
#         messages.warning(request,'Email doesnt match')
#         return redirect('/myapp/login_get/')
#     otp=random.randint(100000,999999)
#     request.session['otp']=str(otp)
#     request.session['email']=email
#
#     send_mail('Your Verification Code',
#               'Your Verification Code is {otp}',
#               settings.EMAIL_HOST_USER,
#               [email],
#               fail_silently=False)
#               messages.success(request,'OTP sent to your Mail')
#               return redirect('/myapp/verifyOtp/')
# def verifyOtp(request)

from django.contrib.auth import get_user_model
from django.http import JsonResponse

User = get_user_model()

# def changePasswordflutter(request):
#     # Expecting POST
#     if request.method != 'POST':
#         return JsonResponse({'status': 'error', 'message': 'Invalid request method'}, status=405)
#
#     email = request.POST.get('email')
#     newpassword = request.POST.get('newPassword')
#     confirmPassword = request.POST.get('confirmPassword')
#
#
#     if not all([email, newpassword, confirmPassword]):
#         return JsonResponse({'status': 'error', 'message': 'Missing parameters'})
#
#     if newpassword != confirmPassword:
#         return JsonResponse({'status': 'error', 'message': 'Passwords do not match'})
#
#     try:
#         user = User.objects.get(email=email)
#     except User.DoesNotExist:
#         return JsonResponse({'status': 'error', 'message': 'User not found'})
#
#     # Use set_password to properly hash the password
#     user.set_password(newpassword)
#     user.save()
#
#     return JsonResponse({'status': 'ok', 'message': 'Password changed successfully'})
def changePasswordflutter(request):
    oldpassword = request.POST['oldpassword']
    newpassword=request.POST['newPassword']
    confirmPassword=request.POST['confirmPassword']
    lid=request.POST['lid']
    print(oldpassword,newpassword,confirmPassword,lid)
    p=User.objects.get(id=lid).password
    print(request.user)
    f=check_password(oldpassword, p)
    if f:
        user = User.objects.get(lid=lid)
        user.set_password(newpassword)
        user.save()
        return JsonResponse({'status':'ok'})
    else:
        return JsonResponpythse({'status': 'no'})




def forgotpasswordflutter(request):
    email = request.POST['email']
    # try:
    user = user_table.objects.get(email=email)
    # except User.DoesNotExist:
    #     return JsonResponse({'status': 'error', 'message': 'Email not found'})

    otp = random.randint(100000, 999999)
    PasswordResetOTP.objects.create(email=email, otp=otp)

    send_mail('Your Verification Code',
              f'Your verification code is {otp}',
              settings.EMAIL_HOST_USER,
              [email],
              fail_silently=False)
    return JsonResponse({'status': 'ok', 'message': 'OTP sent'})


def verifyOtpflutterPost(request):
    email = request.POST['email']
    entered_otp = request.POST['entered_otp']
    otp_obj = PasswordResetOTP.objects.filter(email=email).latest('created_at')
    if otp_obj.otp == entered_otp:
        return JsonResponse({'status': 'ok'})
    else:
        return JsonResponse({'status': 'error'})

#######################################################################
def forget_passwordweb(request):

     return render (request,'admin/fpassword.html')
def forgetpassword_otp(request):
    email=request.POST['email']
    try:
        user=User.objects.get(email=email)
    except User.DoesNotExist:
        messages.warning(request,'Email does not match')
        return redirect('/myapp/login_get/')
    otp=random.randint(100000,999999)
    request.session['otp']=str(otp)
    request.session['email'] = email


    send_mail('Your Verification code',
    'Your Verification Code is{otp}',
    settings.EMAIL_HOST_USER,
    [email],
    fail_silently=False)
    messages.success(request,'Otp sent to your mail')
    return redirect('/myapp/verifyotp/')
def verifyotp(request):
    return render(request,'admin/otpverification.html')
def verifyotp_post(request):
    entered_otp=request.POST['entered_otp']
    if request.session.get('otp') == entered_otp:
        messages.success(request,'otp verified')
        return redirect('/myapp/newpassword/')
    else:
        messages.warning(request,'Invalid Otp!')
        return redirect('/myapp/')
def newpassword(request):
    return render(request,'newpassword.html')


