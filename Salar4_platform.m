%%sucide test
BAI=input('please enter your BAI score\n');
BDI=input('please enter your BDI-II score\n');
if BAI>26
    clc;
    fprintf('the patient needs to enroll protocol 1 \n')
end
if BDI>30
    %لطفا یس و نو را با حروف کوچک تایپ کن
    LogiFirstQu=strcmp(input('Do you feel sucidal? plese answer using yes/no \n ','s'),'yes');
    LogiSecQu=strcmp(input('Have you ever commited sucide? plese answer using yes/no \n','s'),'yes');
    %here it comes the big ifs
    if LogiSecQu
        fprintf('the patient needs to enroll protocol 2 \n')
    elseif LogiFirstQu && (~LogiSecQu)
        fprintf('the patient needs to enroll protocol 3 \n')
    else
        fprintf('the patient needs to enroll protocol 4 \n')
    end
end

%%LoginApp
clc,clear
username=input('Enter a Username: ','s');
clc;
fprintf('Username: %s\n',username);
password=input('Enter a Password: ','s');
secondPassword=input('Confirm Your Password: ','s');

x=~strcmp(password,secondPassword);

if ~x
    clc
    fprintf('Your signup was successfull.\nNow you can sign into your account: %s \n',username)
    secUsername=input('Enter your Username: ','s');
    thirdPassword=input('Enter your Password: ','s');
    xx=(~strcmp(thirdPassword,password))||(~strcmp(secUsername,username));
    if strcmp(thirdPassword,password)&&strcmp(secUsername,username)

        clc
        fprintf('You are signed into your account\n')
    end
    while xx
        clc;
        fprintf('Username or password was incorrect\n')

        secUsername=input('Enter your Username: \n','s');
        thirdPassword=input('Enter your Password: \n','s');
        xx=(~strcmp(thirdPassword,password))||(~strcmp(secUsername,username));
        if strcmp(thirdPassword,password)

            clc
            fprintf('You are signed into your account\n')
        end
    end

end

while x
    clc;
    fprintf('The passwords you enterd were not the same.\n Please enter the password again:\n Username: %s\n',username)
    password=input('Enter a Password: ','s');
    secondPassword=input('Confirm Your Password: ','s');
    x=~strcmp(password,secondPassword);
    if ~x
        clc
        fprintf('Your signup was successfull.\nNow you can sign into your account: %s \n',username)
        secUsername=input('Enter your Username: ','s');
        thirdPassword=input('Enter your Password: ','s');
        xx=(~strcmp(thirdPassword,password))||(~strcmp(secUsername,username));

        if strcmp(thirdPassword,password)&&strcmp(secUsername,username)

            clc
            fprintf('You are signed into your account\n')
        end

        while xx
            clc;
            fprintf('Username or password was incorrect\n')

            secUsername=input('Enter your Username: \n','s');
            thirdPassword=input('Enter your Password: \n','s');
            xx=(~strcmp(thirdPassword,password))||(~strcmp(secUsername,username));
            if ~xx

                clc;
                fprintf('You are signed into your account\n')
            end
        end
    end

end


%%Using Logical Indexing
rng(0);
xx=rand(100,1);
y=(xx(xx>=0.5)).^2;
z=(xx(xx<0.5)+0.7);

%%or Using For loop
rng(0);
xx=rand(100,1);
y=[];
z=[];
for i=1:size(xx)
    if xx(i)>=0.5
        y=[y xx(i).^2];
    else
        z=[z xx(i)+1];
    end
end
