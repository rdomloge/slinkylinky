
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style>
        h1 {
            font-size: 40px;
          }
          
          h2 {
            font-size: 25px;
          }
          
          p {
            font-size: 16px;
          }

          th {
            font-size: 20px;
            color: #100;
          }

          td {
            font-size: 16px;
          }
        </style>
        </head>
    <body>
        <img src="cid:logo-cid" width='200px' style=""/>
        
        
        <p style="clear:both; margin: top 30px;">Hi ${recipientName},</p>
        <p>
            <#list paidLinks as demand, link>
                <p>Your order with Link Sync is now complete. It's been a pleasure doing business with you - here are the details:</p>
                <table border="1" cellpadding="5" cellspacing="0">
                  <tr>
                    <th colspan="6" style="background-color:#100">
                      <h1 style="margin-left: 10px; color: #ffff; text-align: left; margin-left: 5px">Order #${orderNum} complete</h1>
                    </th>
                  </tr>
                  <tr>
                      <th>Anchor text</th>
                      <th>URL</th>
                      <th>DA Needed</th>
                      <th>Post title</th>
                      <th>Post URL</th>
                      <th>Site DA</th>
                  </tr>
                  <tr>
                      <td>${demand.anchorText}</td>
                      <td>${demand.url}</td>
                      <td>${demand.daNeeded}</td>
                      <td>${link.liveLinkTitle}</td>
                      <td>${link.liveLinkUrl}</td>
                      <td>${link.supplierDa}</td>
                  </tr>
            </#list> 
        </p>
        
        <p>
            Any issues please let us know.
        </p>
        <p>Regards,</p>
        <p>
        <em>${senderName}</em> <br />
        info@link-sync.co.uk <br />
        https://www.link-sync.co.uk <br />
        </p>
    </body>
</html>