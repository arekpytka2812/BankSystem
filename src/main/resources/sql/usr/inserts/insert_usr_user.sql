insert into usr_user(login, password)
values('DEVELOPER', digest('haslo', 'sha256')),
      ('SERVICE_USER', digest('service', 'sha256'));