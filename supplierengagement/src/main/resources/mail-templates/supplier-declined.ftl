
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
            Unfortunately, Supplier <em>"${supplierName}"</em> of <em>${supplierDomain}</em> has declined your request for a backlink.
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
        
        <#if declineReason??>
            <p>They gave the following reason: <span style="font-size: 130%">"${declineReason}"</span></p>
        <#else>
            <p>They did not provide a reason for their decision.</p>
        </#if>


        <#if doNotContact>
            <p>The supplier ticked 'do not contact me again', so they have been disabled in the system.</p>   
        <#else>
            <p>They have <em><b>not</b></em> been disabled in the system, so please <u>don't select them again</u> until the developer works out how to stop this from happening in code.</p>
        </#if>
        
        <p>Regards,</p>
        <p>
            <em>Slinky Linky Bot</em> <br />
        </p>

        <img src="cid:logo-cid" width='53px' style="float:left"/>
        <h1 style="float:left; margin-left: 10px; margin-top: 0px">Slinky Linky</h1>
    </body>
</html>