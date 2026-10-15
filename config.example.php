<?php
return [
 'app_name'=>'Oman AI Case Guardian v2',
 'timezone'=>'Asia/Muscat',
 'db'=>['host'=>'localhost','name'=>'oman_case_guardian','user'=>'root','pass'=>'','charset'=>'utf8mb4'],
 'ai'=>[
   'provider'=>'gemini',
   'api_key'=>'',
   'model'=>'YOUR_CURRENT_AVAILABLE_MODEL',
   'max_output_tokens'=>4000
 ],
 'google'=>[
   'client_id'=>'',
   'client_secret'=>'',
   'redirect_uri'=>'https://YOUR-DOMAIN.example.com/google/callback.php'
 ],
 'uploads'=>[
   'max_mb'=>100,
   'allowed_ext'=>['pdf','doc','docx','xls','xlsx','csv','txt','jpg','jpeg','png','webp','zip','eml','msg']
 ]
];
