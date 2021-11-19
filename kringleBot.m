% kringleBot.m
% Jamie Near 2016
% Automated script for organizing a secret santa gift exchange.  This
% script automatically "picks from a hat" to select secret santa for each
% person.  Also offers the option to list "restricted recipients", for
% example, if you have a group of couples but you don't want people to end
% up selecting their own partners.

%List the particpants and their email addresses:
names={'Jane','John','Kim','Karl','Linda','Larry','Mary','Mike','Mike Jr.'};
emailAddresses={...
    'Jane@fakemail.com',...
    'John@fakemail.com',...
    'Kim@fakemail.com',...
    'Karl@fakemail.com',...
    'Linda@fakemail.com',...
    'Larry@fakemail.com',...
    'Mary@fakemail.com',...
    'Mike@fakemail.com'...
    'MikeJr@fakemail.com'};

%Specify a gift limit in Dollars:
giftLimit=50;


%List the restricted recipients.  Use numbers to index each person.
restricted={...
    [2],...%Jane is not allowed to get John
    [1],...%John is not allowed to get Jane
    [4],...%Kim is not alloewed to get Karl
    [3],...%Karl is not allowed to get Kim
    [6],...%Linda is not allowed to get Larry
    [5],...%Larry is not allowed to get Linda
    [8,9],...%Mary is not allowed to get Mike or Mike Jr.
    [7,9],...%Mike is not allowed to get Mary or Mike Jr.
    [7,8]}; %Mike Jr. is not allowed to get Mary or Mike.

remaining=[1:length(names)];

%Do the randomization:
ok=false;
iter=0;
while ~ok
    r=randperm(length(names));
    iter=iter+1;
    ok=true;
    for n=1:length(names)
        if r(n)==n || ismember(restricted{n},r(n))
            ok=false; %THIS RANDOMIZATION WAS NOT OK.  RE-START.
            break;
        end
    end
end

%Display who gets who 
%(Comment this part if you don't want to spoil the surprise!)
for n=1:length(names)
    disp([names{n} ' gets ' names{r(n)}]);
end



%SET UP EMAIL PREFERENCES (TESTED FOR GMAIL.  NOT SURE ABOUT OTHER EMAIL PROVIDERS) :
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail','senderAddress@gmail.com');
setpref('Internet','SMTP_Username','senderAddress@gmail.com');
setpref('Internet','SMTP_Password','yourGmailPasswordHere');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');


%Make an attachment for each person:
for n=1:length(names)
    fid=fopen([names{n} '_SecretSanta.txt'],'w+');
    fprintf(fid,'Dear %s,\n',names{n});
    fprintf(fid,'The Secret Santa results are in!!');
    fprintf(fid,'You got: %s !!\n',names{r(n)});
    fprintf(fid,'Gift Limit is $%2.2f\n',giftLimit);
    fprintf(fid,'Merry Christmas\n');
    fprintf(fid,'P.S.  This message is top secret.  Please destroy!!!');
end


%Automatically send out the emails with attachments:
for n=1:length(names)
    sendmail(...
        emailAddresses{n},...
        'Secret Santa Results (Top Secret)',...
        ['Hello ' names{n} ', please open the attachment to find out who you got for Secret Santa!'],...
        [names{n} '_SecretSanta.txt']);
end

