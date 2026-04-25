import React, { useEffect, useState } from 'react';
import Logo from '@/assets/logo.png';

export default function VerifyEmail() {
  const [status, setStatus] = useState('loading'); // loading | success | invalid | error

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const token = params.get('token');

    if (!token) {
      setStatus('invalid');
      return;
    }

    fetch(`/.rest/accounts/verify-email?token=${encodeURIComponent(token)}`)
      .then(async (res) => {
        if (res.ok) {
          setStatus('success');
        } else {
          const data = await res.json().catch(() => ({}));
          if (data.code === 'INVALID_OR_EXPIRED') {
            setStatus('invalid');
          } else {
            setStatus('error');
          }
        }
      })
      .catch(() => setStatus('error'));
  }, []);

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        background: 'linear-gradient(135deg, #fafbfc 0%, #f5f5f5 50%, #efefef 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontFamily: "'Space Grotesk', sans-serif",
      }}
    >
      <div
        style={{
          textAlign: 'center',
          maxWidth: 420,
          width: '100%',
          padding: '0 2rem',
          animation: 'sl-fade-up 0.55s ease-out 0.1s both',
        }}
      >
        <img
          src={Logo}
          width={Math.round(439 / 8)}
          height={Math.round(498 / 8)}
          alt="SlinkyLinky"
          style={{ opacity: 0.75, marginBottom: 32 }}
        />

        {status === 'loading' && (
          <>
            <h1 style={headingStyle}>Verifying…</h1>
            <p style={bodyStyle}>Please wait while we confirm your email address.</p>
          </>
        )}

        {status === 'success' && (
          <>
            <h1 style={{ ...headingStyle, color: '#6db89d' }}>Email verified!</h1>
            <p style={bodyStyle}>
              Your email address has been confirmed. You can now sign in.
            </p>
            <a href="/" style={buttonStyle}>
              Sign in
            </a>
          </>
        )}

        {status === 'invalid' && (
          <>
            <h1 style={headingStyle}>Link expired</h1>
            <p style={bodyStyle}>
              This verification link is invalid or has already been used.
              <br />
              Sign in and request a new link from the verification screen.
            </p>
            <a href="/" style={buttonStyle}>
              Go to sign in
            </a>
          </>
        )}

        {status === 'error' && (
          <>
            <h1 style={headingStyle}>Something went wrong</h1>
            <p style={bodyStyle}>
              We couldn't verify your email right now. Please try again later.
            </p>
            <a href="/" style={buttonStyle}>
              Go to sign in
            </a>
          </>
        )}
      </div>
    </div>
  );
}

const headingStyle = {
  fontSize: '2rem',
  fontWeight: 800,
  color: 'var(--text-primary)',
  letterSpacing: '-0.04em',
  margin: '0 0 12px',
};

const bodyStyle = {
  color: 'var(--text-secondary)',
  fontSize: '1rem',
  lineHeight: 1.6,
  margin: '0 0 32px',
};

const buttonStyle = {
  display: 'inline-block',
  padding: '0.85rem 2.2rem',
  background: 'linear-gradient(135deg, #a89dbd 0%, #8dcbb3 100%)',
  color: 'white',
  fontFamily: "'Space Grotesk', sans-serif",
  fontWeight: 600,
  fontSize: '0.95rem',
  textDecoration: 'none',
  borderRadius: 12,
  boxShadow: '0 4px 16px rgba(168, 157, 189, 0.25)',
};
