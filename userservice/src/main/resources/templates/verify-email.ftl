<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Verify your email — SlinkyLinky</title>
</head>
<body style="margin:0;padding:0;background:#f5f5f5;font-family:'Segoe UI',Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="padding:40px 0;">
    <tr>
      <td align="center">
        <table width="520" cellpadding="0" cellspacing="0"
               style="background:#ffffff;border-radius:8px;padding:40px;box-shadow:0 2px 8px rgba(0,0,0,.08);">
          <tr>
            <td>
              <p style="font-size:22px;font-weight:600;color:#1a1a2e;margin:0 0 8px;">
                Welcome to SlinkyLinky
              </p>
              <p style="font-size:14px;color:#555;margin:0 0 28px;">
                Please verify your email address to activate your account.
              </p>
              <a href="${verificationLink}"
                 style="display:inline-block;background:#6366f1;color:#fff;padding:12px 28px;
                        border-radius:6px;text-decoration:none;font-size:15px;font-weight:500;">
                Verify email address
              </a>
              <p style="font-size:12px;color:#999;margin:28px 0 0;">
                This link expires in 24 hours. If you did not create an account,
                you can safely ignore this email.
              </p>
              <p style="font-size:12px;color:#bbb;margin:12px 0 0;word-break:break-all;">
                ${verificationLink}
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
