
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
            Unfortunately, Supplier <em>"${supplierName}"</em> of <em>${supplierDomain}</em> has failed to respond to proposal ${proposalId} in a timely manner.
        </p>
        <p>
            <b>The Proposal has been automatically aborted.</b>
        </p>
        <p>This proposal was for
            <ul>
                <li>${demand1Domain}</li>
                
                <#if demand2Domain??>
                <li>${demand2Domain}</li>
                </#if>
                
                <#if demand3Domain??>
                <li>${demand3Domain}</li>
                </#if>
            </ul>
        </p>
        
        <p>The engagement email was sent on ${sentDate} and the deadline was ${deadlineDate}.</p>
        
        <p>Regards,</p>
        <p>
            <em>Slinky Linky Bot</em> <br />
        </p>

        <img src="cid:logo-cid" width='53px' style="float:left"/>
        <h1 style="float:left; margin-left: 10px; margin-top: 0px">Slinky Linky</h1>
    </body>
</html>