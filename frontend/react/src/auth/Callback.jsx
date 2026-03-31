import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { exchangeCodeForTokens, useAuth } from './AuthProvider';
import Logo from '@/assets/logo.png';

export default function Callback() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [error, setError] = useState(null);
  const { loadSession } = useAuth();

  useEffect(() => {
    const code = searchParams.get('code');
    if (!code) {
      setError('No authorization code received');
      return;
    }

    exchangeCodeForTokens(code)
      .then(() => loadSession())
      .then(() => {
        const returnTo = sessionStorage.getItem('sl_return_to') || '/';
        sessionStorage.removeItem('sl_return_to');
        sessionStorage.setItem('sl_just_authenticated', 'true');
        navigate(returnTo, { replace: true });
      })
      .catch((err) => {
        console.error('Token exchange failed:', err);
        setError('Authentication failed. Please try again.');
      });
  }, [searchParams, navigate]);

  const darkBg = {
    display: 'flex', flexDirection: 'column', justifyContent: 'center',
    alignItems: 'center', height: '100vh',
    background: 'linear-gradient(135deg, #0a0e1a 0%, #0f172a 60%, #1e1b4b 100%)',
    fontFamily: "'Outfit', sans-serif",
  };

  if (error) {
    return (
      <div style={{ ...darkBg, gap: 20 }}>
        <img
          src={Logo} width={40} height={45} alt="SlinkyLinky"
          style={{ filter: 'brightness(0) invert(1)', opacity: 0.45 }}
        />
        <p style={{ color: '#fca5a5', fontSize: '0.95rem', fontWeight: 500 }}>{error}</p>
        <button
          onClick={() => (window.location.href = '/')}
          style={{
            padding: '0.6rem 1.5rem',
            background: 'rgba(99,102,241,0.12)', color: '#a5b4fc',
            border: '1px solid rgba(99,102,241,0.28)',
            borderRadius: 8, cursor: 'pointer',
            fontFamily: "'Outfit', sans-serif", fontSize: '0.875rem', fontWeight: 500,
          }}
        >
          Try again
        </button>
      </div>
    );
  }

  return (
    <div style={{ ...darkBg, gap: 24 }}>
      {/* Pulsing logo with rings */}
      <div style={{ position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <img
          src={Logo} width={48} height={54} alt="SlinkyLinky"
          style={{
            filter: 'brightness(0) invert(1)',
            animation: 'sl-callback-breathe 2s ease-in-out infinite',
          }}
        />
        <div style={{
          position: 'absolute', width: 90, height: 90, borderRadius: '50%',
          border: '1.5px solid rgba(167,139,250,0.3)',
          animation: 'sl-ping-ring 1.8s ease-out infinite',
        }} />
        <div style={{
          position: 'absolute', width: 72, height: 72, borderRadius: '50%',
          border: '1px solid rgba(99,102,241,0.2)',
          animation: 'sl-ping-ring 1.8s ease-out infinite',
          animationDelay: '0.45s',
        }} />
      </div>

      {/* Wordmark */}
      <span style={{ fontSize: '1.1rem', fontWeight: 700, color: 'white', letterSpacing: '-0.03em' }}>
        Slinky<span style={{ color: '#a78bfa' }}>Linky</span>
      </span>

      {/* Status with animated dots */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
        <span style={{ color: 'rgba(148,163,184,0.65)', fontSize: '0.875rem' }}>
          Completing sign in
        </span>
        {[0, 200, 400].map(d => (
          <span key={d} style={{
            width: 3, height: 3, borderRadius: '50%',
            background: 'rgba(167,139,250,0.55)',
            animation: 'sl-loading-dot 1.2s ease-in-out infinite',
            animationDelay: `${d}ms`,
          }} />
        ))}
      </div>
    </div>
  );
}
