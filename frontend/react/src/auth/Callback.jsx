import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { exchangeCodeForTokens } from './AuthProvider';

export default function Callback() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [error, setError] = useState(null);

  useEffect(() => {
    const code = searchParams.get('code');
    if (!code) {
      setError('No authorization code received');
      return;
    }

    exchangeCodeForTokens(code)
      .then(() => {
        const returnTo = sessionStorage.getItem('sl_return_to') || '/demand';
        sessionStorage.removeItem('sl_return_to');
        navigate(returnTo, { replace: true });
      })
      .catch((err) => {
        console.error('Token exchange failed:', err);
        setError('Authentication failed. Please try again.');
      });
  }, [searchParams, navigate]);

  if (error) {
    return (
      <div className="flex flex-col justify-center items-center h-screen">
        <p className="text-red-500 text-2xl">{error}</p>
        <button
          onClick={() => (window.location.href = '/')}
          className="mt-4 bg-blue-500 text-white px-4 py-2 rounded"
        >
          Try again
        </button>
      </div>
    );
  }

  return (
    <div className="flex justify-center items-center h-screen">
      Completing sign in...
    </div>
  );
}
