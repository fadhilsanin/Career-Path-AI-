from django.db import models
from  django.contrib.auth.models import User

# Create your models here.


class guide(models.Model):
    LOGIN=models.ForeignKey(User,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    gender=models.CharField(max_length=100)
    DOB=models.DateField()
    phone=models.BigIntegerField()
    email=models.CharField(max_length=100)
    qualifiication=models.CharField(max_length=100)
    experience=models.CharField(max_length=100)
    status=models.CharField(max_length=100)

class company_table(models.Model):
    LOGIN=models.ForeignKey(User,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    phone=models.BigIntegerField()
    since=models.CharField(max_length=100)
    place=models.CharField(max_length=100)
    pincode=models.BigIntegerField()
    district=models.CharField(max_length=100)
    latitude=models.CharField(max_length=100)
    longitude=models.CharField(max_length=100)
    photo=models.FileField()
    proof=models.FileField()
    status=models.CharField(max_length=100)
    state=models.CharField(max_length=100)

class user_table(models.Model):
    LOGIN=models.ForeignKey(User,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    phone=models.BigIntegerField()
    dob=models.DateField()
    since=models.CharField(max_length=100)
    gender=models.CharField(max_length=100)
    place=models.CharField(max_length=100)
    pincode=models.BigIntegerField()
    district=models.CharField(max_length=100)
    state=models.CharField(max_length=100)
    photo=models.FileField()
    resume=models.FileField()


class complaint(models.Model):
    date=models.DateField()
    USER=models.ForeignKey(user_table,on_delete=models.CASCADE)
    complaint=models.CharField(max_length=100)
    reply=models.CharField(max_length=100)




class guide_review(models.Model):
    date=models.DateField()
    review=models.CharField(max_length=100)
    rating=models.FloatField()
    USER=models.ForeignKey(user_table,on_delete=models.CASCADE)
    GUIDE=models.ForeignKey(guide,on_delete=models.CASCADE)
    data=models.CharField(max_length=100)

class company_review(models.Model):
    date=models.DateField()
    COMPANY=models.ForeignKey(company_table,on_delete=models.CASCADE)
    USER=models.ForeignKey(user_table,on_delete=models.CASCADE)
    review=models.CharField(max_length=100)
    rating=models.FloatField()

class exam_info(models.Model):
    exam_name=models.CharField(max_length=100)
    details=models.CharField(max_length=100)
    last_date=models.DateField()
    link=models.CharField(max_length=100)

class vaccancy(models.Model):
    COMPANY=models.ForeignKey(company_table,on_delete=models.CASCADE)
    vaccancy=models.CharField(max_length=100)
    details=models.CharField(max_length=100)
    salary=models.CharField(max_length=100)
    experience=models.CharField(max_length=100)
    qualification=models.CharField(max_length=100)
    requirement=models.CharField(max_length=100)
    date=models.DateField()
    no_of_vaccancy=models.CharField(max_length=100)

class appliccation(models.Model):
    VACCANCY=models.ForeignKey(vaccancy,on_delete=models.CASCADE)
    USER=models.ForeignKey(user_table,on_delete=models.CASCADE)
    date=models.DateField()
    score=models.FloatField()
    status=models.CharField(max_length=100)
    interview_date=models.DateField(null=True)
    Resume=models.FileField()

class user_request(models.Model):
    USER=models.ForeignKey(user_table,on_delete=models.CASCADE)
    GUIDE=models.ForeignKey(guide,on_delete=models.CASCADE)
    request=models.CharField(max_length=100)
    date=models.DateField()
    status=models.CharField(max_length=100)

class tips(models.Model):
    GUIDE=models.ForeignKey(guide,on_delete=models.CASCADE)
    tips=models.CharField(max_length=100)
    discriptio=models.CharField(max_length=100)
    date=models.DateField()

class videos(models.Model):
    GUIDE=models.ForeignKey(guide,on_delete=models.CASCADE)
    title=models.CharField(max_length=100)
    vedios=models.FileField()
    date=models.DateField()

class qustionpaper(models.Model):
    GUIDE=models.ForeignKey(guide,on_delete=models.CASCADE)
    EXAM=models.ForeignKey(exam_info,on_delete=models.CASCADE)
    qustionpaper=models.FileField()
    answersheet=models.FileField()
    year=models.CharField(max_length=100)




class app_feedback(models.Model):
    USER=models.ForeignKey(user_table,on_delete=models.CASCADE)
    feedback=models.CharField(max_length=100)
    date=models.DateField()
    status=models.CharField(max_length=100)
    rating=models.FloatField()



class PasswordResetOTP(models.Model):
    email=models.EmailField()
    otp=models.CharField(max_length=6)
    created_at=models.DateTimeField(auto_now_add=True)






















