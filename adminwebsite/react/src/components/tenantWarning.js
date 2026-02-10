import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';

// Regex patterns for users who should see warnings
const allowedUserPatterns = [
  /^rdomloge@gmail\.com$/,
  /^.*@frontpageadvantage\.com$/
];
const environmentConfigs = {
  testClient: {
    type: 'TopClick Environment:',
    message: 'You are on the TopClick domain - not production',
    colors: {
      bg: 'bg-yellow-100',
      border: 'border-yellow-500',
      text: 'text-yellow-700',
      icon: 'text-yellow-400'
    }
  },
  development: {
    type: 'Development Environment:',
    messageTemplate: 'You are currently on {domain}',
    colors: {
      bg: 'bg-green-100',
      border: 'border-green-500',
      text: 'text-green-700',
      icon: 'text-green-400'
    }
  }
};

export default function TenantWarning() {
  const { data: session } = useSession();
  const [domain, setDomain] = useState('');
  const [showWarning, setShowWarning] = useState(false);
  const [warningType, setWarningType] = useState('');
  const [warningMessage, setWarningMessage] = useState('');
  const [bgColor, setBgColor] = useState('bg-yellow-100');
  const [borderColor, setBorderColor] = useState('border-yellow-500');
  const [textColor, setTextColor] = useState('text-yellow-700');
  const [iconColor, setIconColor] = useState('text-yellow-400');

  // Check if current user should see warnings
  const shouldShowWarningForUser = () => {
    if (!session?.user?.email) return false;
    return allowedUserPatterns.some(pattern => pattern.test(session.user.email));
  };

  // Helper function to set warning configuration
  const setWarningConfig = (configKey, domain = '') => {
    const config = environmentConfigs[configKey];
    setShowWarning(true);
    setWarningType(config.type);
    
    // Handle message template replacement
    const message = config.messageTemplate 
      ? config.messageTemplate.replace('{domain}', domain)
      : config.message;
    setWarningMessage(message);
    
    // Set colors
    setBgColor(config.colors.bg);
    setBorderColor(config.colors.border);
    setTextColor(config.colors.text);
    setIconColor(config.colors.icon);
  };

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const currentDomain = window.location.hostname;
      setDomain(currentDomain);
      
      // Check if user should see warnings first
      if (!shouldShowWarningForUser()) {
        setShowWarning(false);
        return;
      }
      
      // Production domain should not show warning
      if (currentDomain === 'slinkylinky.uk') {
        setShowWarning(false);
        return;
      }
      
      // Configure warning based on domain type
      if (currentDomain === 'tc.slinkylinky.uk') {
        setWarningConfig('testClient');
      } else if (currentDomain.includes('localhost') || 
                 currentDomain.includes('staging') || 
                 currentDomain.includes('dev') || 
                 currentDomain.includes('test')) {
        setWarningConfig('development', currentDomain);
      } else {
        setShowWarning(false);
      }
    }
  }, [session]); // Add session as dependency

  if (!showWarning) {
    return null;
  }

  return (
    <div className={`${bgColor} border-l-4 ${borderColor} ${textColor} p-4`}>
      <div className="flex">
        <div className="flex-shrink-0">
          <svg className={`h-5 w-5 ${iconColor}`} viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
          </svg>
        </div>
        <div className="ml-3">
          <p className="text-sm">
            <strong>{warningType}</strong> {warningMessage}
          </p>
        </div>
      </div>
    </div>
  );
}