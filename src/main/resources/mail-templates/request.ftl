
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style>
        h1 {
            font-size: 40px;
          }
          
          h2 {
            font-size: 30px;
          }
          
          p {
            font-size: 14px;
          }
        </style>
        </head>
    <body>        
        <p style="clear:both; margin: top 30px;">Hi ${recipientName},</p>
        <p>
            Are you able to post the attached on your website ${website} please. 
            
            I have included the markdown version of the article, plus an HTML version.
            
            Once the article is live, please click <a href='${responseUrl}'>here</a>
            and provide the live link to the article and upload your invoice if possible and I&apos;ll 
            make payment in the next couple of days. 
        </p>
        <p>
            Our supported method of payment is PayPal for the agreed fee of ${fee}.
        </p>
        
        <p>
            Any issues please let me know.
        </p>
        <p>Regards,</p>
        <p>
        <em>${signoff}</em> <br />
        <em>${signoffContactDetails} <br />
        </p>

        <img src="cid:logo-cid" width='53px' style="float:left"/>
        <h1 style="float:left; margin-left: 10px; margin-top: 0px">Slinky Linky</h1>
    </body>
</html>