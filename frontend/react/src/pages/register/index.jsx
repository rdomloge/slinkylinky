import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import Logo from '@/assets/logo.png';

const AnimatedNetworkVisualization = () => {
    const [particles, setParticles] = useState([]);

    useEffect(() => {
        const nodes = [
            { id: 1, x: 20, y: 30, vx: 0.3, vy: 0.2, size: 3 },
            { id: 2, x: 60, y: 40, vx: -0.25, vy: 0.35, size: 2.5 },
            { id: 3, x: 80, y: 70, vx: 0.2, vy: -0.3, size: 3.5 },
            { id: 4, x: 40, y: 80, vx: -0.3, vy: -0.2, size: 2 },
            { id: 5, x: 70, y: 20, vx: 0.25, vy: 0.4, size: 3 },
            { id: 6, x: 30, y: 60, vx: 0.15, vy: -0.25, size: 2.5 },
        ];
        setParticles(nodes);
    }, []);

    return (
        <svg
            style={{
                position: 'absolute',
                inset: 0,
                width: '100%',
                height: '100%',
                pointerEvents: 'none',
            }}
            viewBox="0 0 100 100"
            preserveAspectRatio="xMidYMid slice"
        >
            <defs>
                <radialGradient id="nodeGlow" cx="50%" cy="50%" r="50%">
                    <stop offset="0%" stopColor="#00d9ff" stopOpacity="0.8" />
                    <stop offset="100%" stopColor="#00d9ff" stopOpacity="0" />
                </radialGradient>
                <filter id="glow">
                    <feGaussianBlur stdDeviation="1.5" result="coloredBlur" />
                    <feMerge>
                        <feMergeNode in="coloredBlur" />
                        <feMergeNode in="SourceGraphic" />
                    </feMerge>
                </filter>
            </defs>

            {/* Animated connection lines */}
            <g opacity="0.2" stroke="#00d9ff" strokeWidth="0.3" fill="none">
                <line x1="20" y1="30" x2="60" y2="40" />
                <line x1="60" y1="40" x2="80" y2="70" />
                <line x1="80" y1="70" x2="40" y2="80" />
                <line x1="40" y1="80" x2="30" y2="60" />
                <line x1="30" y1="60" x2="20" y2="30" />
                <line x1="60" y1="40" x2="70" y2="20" />
                <line x1="70" y1="20" x2="80" y2="70" />
            </g>

            {/* Glowing nodes */}
            <g filter="url(#glow)">
                <circle cx="20" cy="30" r="3.5" fill="#00d9ff" opacity="0.6" />
                <circle cx="60" cy="40" r="2.8" fill="#00d9ff" opacity="0.7" />
                <circle cx="80" cy="70" r="4" fill="#00d9ff" opacity="0.5" />
                <circle cx="40" cy="80" r="2.5" fill="#00d9ff" opacity="0.6" />
                <circle cx="70" cy="20" r="3.2" fill="#00d9ff" opacity="0.65" />
                <circle cx="30" cy="60" r="2.8" fill="#00d9ff" opacity="0.7" />
            </g>
        </svg>
    );
};

export default function Register() {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        email: '',
        companyName: '',
        password: '',
        passwordConfirm: '',
    });
    const [errors, setErrors] = useState({});
    const [submitting, setSubmitting] = useState(false);
    const [serverError, setServerError] = useState('');

    const validateForm = () => {
        const newErrors = {};

        if (!formData.firstName.trim()) {
            newErrors.firstName = 'First name is required';
        } else if (formData.firstName.trim().length > 80) {
            newErrors.firstName = 'First name must be 80 characters or less';
        }

        if (!formData.lastName.trim()) {
            newErrors.lastName = 'Last name is required';
        } else if (formData.lastName.trim().length > 80) {
            newErrors.lastName = 'Last name must be 80 characters or less';
        }

        if (!formData.email.trim()) {
            newErrors.email = 'Email is required';
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
            newErrors.email = 'Please enter a valid email address';
        }

        if (!formData.companyName.trim()) {
            newErrors.companyName = 'Company name is required';
        } else if (formData.companyName.trim().length < 2) {
            newErrors.companyName = 'Company name must be at least 2 characters';
        } else if (formData.companyName.trim().length > 120) {
            newErrors.companyName = 'Company name must be 120 characters or less';
        }

        if (!formData.password) {
            newErrors.password = 'Password is required';
        } else if (formData.password.length < 8) {
            newErrors.password = 'Password must be at least 8 characters';
        }

        if (!formData.passwordConfirm) {
            newErrors.passwordConfirm = 'Please confirm your password';
        } else if (formData.password !== formData.passwordConfirm) {
            newErrors.passwordConfirm = 'Passwords do not match';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prev) => ({
            ...prev,
            [name]: value,
        }));
        if (errors[name]) {
            setErrors((prev) => ({
                ...prev,
                [name]: '',
            }));
        }
        setServerError('');
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validateForm()) return;

        setSubmitting(true);
        try {
            const response = await fetch('/.rest/accounts/registration', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    firstName: formData.firstName,
                    lastName: formData.lastName,
                    email: formData.email,
                    companyName: formData.companyName,
                    password: formData.password,
                }),
            });

            if (response.ok) {
                navigate('/?registered=true');
                return;
            }

            const data = await response.json();

            if (response.status === 409 && data.code === 'EMAIL_EXISTS') {
                setErrors((prev) => ({
                    ...prev,
                    email: 'An account with this email already exists',
                }));
            } else if (response.status === 429) {
                setServerError('Too many registration attempts. Please try again later.');
            } else if (response.status === 400 && data.errors) {
                // Validation errors from backend
                setErrors((prev) => ({
                    ...prev,
                    ...data.errors,
                }));
            } else {
                setServerError(data.message || 'Registration failed. Please try again.');
            }
        } catch (error) {
            setServerError('An error occurred. Please try again.');
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <div
            style={{
                position: 'fixed',
                inset: 0,
                background: 'linear-gradient(135deg, #0f1419 0%, #1a1f28 50%, #0d1117 100%)',
                overflow: 'hidden',
                fontFamily: "'Sora', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
                zIndex: 1,
            }}
        >
            <style>{`
                @import url('https://fonts.googleapis.com/css2?family=Sora:wght@400;500;600;700;800&display=swap');

                @keyframes float-up {
                    0%, 100% { transform: translateY(0px); }
                    50% { transform: translateY(-20px); }
                }

                @keyframes pulse-glow {
                    0%, 100% { opacity: 0.6; }
                    50% { opacity: 1; }
                }

                @keyframes shimmer {
                    0% { background-position: -1000px 0; }
                    100% { background-position: 1000px 0; }
                }

                input::placeholder {
                    color: rgba(148, 163, 184, 0.7);
                }

                input:focus {
                    outline: none;
                }
            `}</style>

            {/* Background elements */}
            <div
                style={{
                    position: 'absolute',
                    inset: 0,
                    zIndex: 0,
                }}
            >
                {/* Ambient glow top-left */}
                <div
                    style={{
                        position: 'absolute',
                        top: '-20%',
                        left: '-10%',
                        width: 600,
                        height: 600,
                        background: 'radial-gradient(circle, rgba(0, 217, 255, 0.08) 0%, transparent 70%)',
                        borderRadius: '50%',
                        filter: 'blur(80px)',
                        pointerEvents: 'none',
                    }}
                />
                {/* Ambient glow bottom-right */}
                <div
                    style={{
                        position: 'absolute',
                        bottom: '-15%',
                        right: '-10%',
                        width: 700,
                        height: 700,
                        background: 'radial-gradient(circle, rgba(0, 217, 255, 0.05) 0%, transparent 70%)',
                        borderRadius: '50%',
                        filter: 'blur(90px)',
                        pointerEvents: 'none',
                    }}
                />
            </div>

            {/* Split layout container */}
            <div
                style={{
                    position: 'relative',
                    zIndex: 10,
                    display: 'flex',
                    height: '100%',
                    overflow: 'hidden',
                }}
            >
                {/* Left side: Visual storytelling */}
                <div
                    style={{
                        flex: '1 1 55%',
                        position: 'relative',
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                        justifyContent: 'center',
                        padding: '2rem',
                        overflow: 'hidden',
                    }}
                >
                    <AnimatedNetworkVisualization />

                    {/* Overlay content on left */}
                    <div
                        style={{
                            position: 'relative',
                            zIndex: 5,
                            textAlign: 'center',
                            maxWidth: 380,
                            animation: 'sl-fade-up 0.8s ease-out 0.2s both',
                        }}
                    >
                        <div
                            style={{
                                fontSize: '3.5rem',
                                fontWeight: 800,
                                background: 'linear-gradient(135deg, #00d9ff 0%, #0099cc 100%)',
                                backgroundClip: 'text',
                                WebkitBackgroundClip: 'text',
                                WebkitTextFillColor: 'transparent',
                                marginBottom: '1.5rem',
                                letterSpacing: '-0.02em',
                                lineHeight: 1.1,
                            }}
                        >
                            Build your link empire
                        </div>
                        <p
                            style={{
                                fontSize: '1.05rem',
                                color: 'rgba(203, 213, 225, 0.8)',
                                lineHeight: 1.6,
                                fontWeight: 400,
                            }}
                        >
                            Connect with suppliers, manage links, and dominate search rankings. All in one platform.
                        </p>
                    </div>
                </div>

                {/* Right side: Registration form */}
                <div
                    style={{
                        flex: '0 0 45%',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        padding: '3rem 2rem',
                        background: 'rgba(15, 20, 25, 0.6)',
                        backdropFilter: 'blur(10px)',
                        borderLeft: '1px solid rgba(0, 217, 255, 0.1)',
                        overflowY: 'auto',
                    }}
                >
                    {/* Form wrapper */}
                    <div
                        style={{
                            width: '100%',
                            maxWidth: 380,
                        }}
                    >
                        {/* Logo + wordmark */}
                        <div
                            style={{
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'flex-start',
                                gap: 12,
                                marginBottom: 40,
                                animation: 'sl-fade-up 0.6s ease-out 0.1s both',
                            }}
                        >
                            <img
                                src={Logo}
                                width={28}
                                height={28}
                                alt="SlinkyLinky"
                                style={{ opacity: 0.9 }}
                            />
                            <span
                                style={{
                                    fontSize: '1.4rem',
                                    fontWeight: 700,
                                    color: 'rgba(203, 213, 225, 0.95)',
                                    letterSpacing: '-0.01em',
                                    lineHeight: 1,
                                }}
                            >
                                Slinky<span style={{ color: '#00d9ff' }}>Linky</span>
                            </span>
                        </div>

                        {/* Headline */}
                        <h1
                            style={{
                                fontSize: '1.85rem',
                                fontWeight: 800,
                                color: 'rgba(203, 213, 225, 0.98)',
                                letterSpacing: '-0.02em',
                                lineHeight: 1.2,
                                margin: '0 0 8px',
                                animation: 'sl-fade-up 0.6s ease-out 0.15s both',
                            }}
                        >
                            Join SlinkyLinky
                        </h1>

                        {/* Subheading */}
                        <p
                            style={{
                                color: 'rgba(148, 163, 184, 0.8)',
                                fontSize: '0.9rem',
                                lineHeight: 1.5,
                                margin: '0 0 28px',
                                animation: 'sl-fade-up 0.6s ease-out 0.2s both',
                                fontWeight: 400,
                            }}
                        >
                            Create your account and start building your link empire.
                        </p>

                        {/* Form */}
                        <form onSubmit={handleSubmit} noValidate style={{ animation: 'sl-fade-up 0.6s ease-out 0.25s both' }}>
                            {/* First name field */}
                            <div style={{ marginBottom: 18 }}>
                                <label
                                    htmlFor="firstName"
                                    style={{
                                        display: 'block',
                                        fontSize: '0.8rem',
                                        fontWeight: 600,
                                        color: 'rgba(203, 213, 225, 0.9)',
                                        marginBottom: 7,
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                    }}
                                >
                                    First name
                                </label>
                                <input
                                    id="firstName"
                                    name="firstName"
                                    type="text"
                                    value={formData.firstName}
                                    onChange={handleChange}
                                    placeholder="John"
                                    style={{
                                        width: '100%',
                                        padding: '0.8rem 1rem',
                                        fontSize: '0.95rem',
                                        fontFamily: 'inherit',
                                        border: `1.5px solid ${errors.firstName ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`,
                                        borderRadius: 8,
                                        background: 'rgba(30, 41, 59, 0.6)',
                                        boxSizing: 'border-box',
                                        transition: 'all 0.25s ease',
                                        color: 'rgba(203, 213, 225, 0.95)',
                                        backdropFilter: 'blur(8px)',
                                    }}
                                    onFocus={(e) => {
                                        if (!errors.firstName) {
                                            e.target.style.borderColor = 'rgba(0, 217, 255, 0.5)';
                                            e.target.style.background = 'rgba(30, 41, 59, 0.8)';
                                            e.target.style.boxShadow = '0 0 20px rgba(0, 217, 255, 0.1)';
                                        }
                                    }}
                                    onBlur={(e) => {
                                        e.target.style.borderColor = `${errors.firstName ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`;
                                        e.target.style.background = 'rgba(30, 41, 59, 0.6)';
                                        e.target.style.boxShadow = 'none';
                                    }}
                                />
                                {errors.firstName && (
                                    <p style={{ fontSize: '0.75rem', color: '#ff6b6b', margin: '5px 0 0', fontWeight: 500 }}>
                                        {errors.firstName}
                                    </p>
                                )}
                            </div>

                            {/* Last name field */}
                            <div style={{ marginBottom: 18 }}>
                                <label
                                    htmlFor="lastName"
                                    style={{
                                        display: 'block',
                                        fontSize: '0.8rem',
                                        fontWeight: 600,
                                        color: 'rgba(203, 213, 225, 0.9)',
                                        marginBottom: 7,
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                    }}
                                >
                                    Last name
                                </label>
                                <input
                                    id="lastName"
                                    name="lastName"
                                    type="text"
                                    value={formData.lastName}
                                    onChange={handleChange}
                                    placeholder="Doe"
                                    style={{
                                        width: '100%',
                                        padding: '0.8rem 1rem',
                                        fontSize: '0.95rem',
                                        fontFamily: 'inherit',
                                        border: `1.5px solid ${errors.lastName ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`,
                                        borderRadius: 8,
                                        background: 'rgba(30, 41, 59, 0.6)',
                                        boxSizing: 'border-box',
                                        transition: 'all 0.25s ease',
                                        color: 'rgba(203, 213, 225, 0.95)',
                                        backdropFilter: 'blur(8px)',
                                    }}
                                    onFocus={(e) => {
                                        if (!errors.lastName) {
                                            e.target.style.borderColor = 'rgba(0, 217, 255, 0.5)';
                                            e.target.style.background = 'rgba(30, 41, 59, 0.8)';
                                            e.target.style.boxShadow = '0 0 20px rgba(0, 217, 255, 0.1)';
                                        }
                                    }}
                                    onBlur={(e) => {
                                        e.target.style.borderColor = `${errors.lastName ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`;
                                        e.target.style.background = 'rgba(30, 41, 59, 0.6)';
                                        e.target.style.boxShadow = 'none';
                                    }}
                                />
                                {errors.lastName && (
                                    <p style={{ fontSize: '0.75rem', color: '#ff6b6b', margin: '5px 0 0', fontWeight: 500 }}>
                                        {errors.lastName}
                                    </p>
                                )}
                            </div>

                            {/* Email field */}
                            <div style={{ marginBottom: 18 }}>
                                <label
                                    htmlFor="email"
                                    style={{
                                        display: 'block',
                                        fontSize: '0.8rem',
                                        fontWeight: 600,
                                        color: 'rgba(203, 213, 225, 0.9)',
                                        marginBottom: 7,
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                    }}
                                >
                                    Email address
                                </label>
                                <input
                                    id="email"
                                    name="email"
                                    type="email"
                                    value={formData.email}
                                    onChange={handleChange}
                                    placeholder="your@email.com"
                                    style={{
                                        width: '100%',
                                        padding: '0.8rem 1rem',
                                        fontSize: '0.95rem',
                                        fontFamily: 'inherit',
                                        border: `1.5px solid ${errors.email ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`,
                                        borderRadius: 8,
                                        background: 'rgba(30, 41, 59, 0.6)',
                                        boxSizing: 'border-box',
                                        transition: 'all 0.25s ease',
                                        color: 'rgba(203, 213, 225, 0.95)',
                                        backdropFilter: 'blur(8px)',
                                    }}
                                    onFocus={(e) => {
                                        if (!errors.email) {
                                            e.target.style.borderColor = 'rgba(0, 217, 255, 0.5)';
                                            e.target.style.background = 'rgba(30, 41, 59, 0.8)';
                                            e.target.style.boxShadow = '0 0 20px rgba(0, 217, 255, 0.1)';
                                        }
                                    }}
                                    onBlur={(e) => {
                                        e.target.style.borderColor = `${errors.email ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`;
                                        e.target.style.background = 'rgba(30, 41, 59, 0.6)';
                                        e.target.style.boxShadow = 'none';
                                    }}
                                />
                                {errors.email && (
                                    <p style={{ fontSize: '0.75rem', color: '#ff6b6b', margin: '5px 0 0', fontWeight: 500 }}>
                                        {errors.email}
                                    </p>
                                )}
                            </div>

                            {/* Company name field */}
                            <div style={{ marginBottom: 18 }}>
                                <label
                                    htmlFor="companyName"
                                    style={{
                                        display: 'block',
                                        fontSize: '0.8rem',
                                        fontWeight: 600,
                                        color: 'rgba(203, 213, 225, 0.9)',
                                        marginBottom: 7,
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                    }}
                                >
                                    Company name
                                </label>
                                <input
                                    id="companyName"
                                    name="companyName"
                                    type="text"
                                    value={formData.companyName}
                                    onChange={handleChange}
                                    placeholder="Your company"
                                    style={{
                                        width: '100%',
                                        padding: '0.8rem 1rem',
                                        fontSize: '0.95rem',
                                        fontFamily: 'inherit',
                                        border: `1.5px solid ${errors.companyName ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`,
                                        borderRadius: 8,
                                        background: 'rgba(30, 41, 59, 0.6)',
                                        boxSizing: 'border-box',
                                        transition: 'all 0.25s ease',
                                        color: 'rgba(203, 213, 225, 0.95)',
                                        backdropFilter: 'blur(8px)',
                                    }}
                                    onFocus={(e) => {
                                        if (!errors.companyName) {
                                            e.target.style.borderColor = 'rgba(0, 217, 255, 0.5)';
                                            e.target.style.background = 'rgba(30, 41, 59, 0.8)';
                                            e.target.style.boxShadow = '0 0 20px rgba(0, 217, 255, 0.1)';
                                        }
                                    }}
                                    onBlur={(e) => {
                                        e.target.style.borderColor = `${errors.companyName ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`;
                                        e.target.style.background = 'rgba(30, 41, 59, 0.6)';
                                        e.target.style.boxShadow = 'none';
                                    }}
                                />
                                {errors.companyName && (
                                    <p style={{ fontSize: '0.75rem', color: '#ff6b6b', margin: '5px 0 0', fontWeight: 500 }}>
                                        {errors.companyName}
                                    </p>
                                )}
                            </div>

                            {/* Password field */}
                            <div style={{ marginBottom: 18 }}>
                                <label
                                    htmlFor="password"
                                    style={{
                                        display: 'block',
                                        fontSize: '0.8rem',
                                        fontWeight: 600,
                                        color: 'rgba(203, 213, 225, 0.9)',
                                        marginBottom: 7,
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                    }}
                                >
                                    Password
                                </label>
                                <input
                                    id="password"
                                    name="password"
                                    type="password"
                                    value={formData.password}
                                    onChange={handleChange}
                                    placeholder="At least 8 characters"
                                    style={{
                                        width: '100%',
                                        padding: '0.8rem 1rem',
                                        fontSize: '0.95rem',
                                        fontFamily: 'inherit',
                                        border: `1.5px solid ${errors.password ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`,
                                        borderRadius: 8,
                                        background: 'rgba(30, 41, 59, 0.6)',
                                        boxSizing: 'border-box',
                                        transition: 'all 0.25s ease',
                                        color: 'rgba(203, 213, 225, 0.95)',
                                        backdropFilter: 'blur(8px)',
                                    }}
                                    onFocus={(e) => {
                                        if (!errors.password) {
                                            e.target.style.borderColor = 'rgba(0, 217, 255, 0.5)';
                                            e.target.style.background = 'rgba(30, 41, 59, 0.8)';
                                            e.target.style.boxShadow = '0 0 20px rgba(0, 217, 255, 0.1)';
                                        }
                                    }}
                                    onBlur={(e) => {
                                        e.target.style.borderColor = `${errors.password ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`;
                                        e.target.style.background = 'rgba(30, 41, 59, 0.6)';
                                        e.target.style.boxShadow = 'none';
                                    }}
                                />
                                {errors.password && (
                                    <p style={{ fontSize: '0.75rem', color: '#ff6b6b', margin: '5px 0 0', fontWeight: 500 }}>
                                        {errors.password}
                                    </p>
                                )}
                            </div>

                            {/* Password confirm field */}
                            <div style={{ marginBottom: 24 }}>
                                <label
                                    htmlFor="passwordConfirm"
                                    style={{
                                        display: 'block',
                                        fontSize: '0.8rem',
                                        fontWeight: 600,
                                        color: 'rgba(203, 213, 225, 0.9)',
                                        marginBottom: 7,
                                        textTransform: 'uppercase',
                                        letterSpacing: '0.05em',
                                    }}
                                >
                                    Confirm password
                                </label>
                                <input
                                    id="passwordConfirm"
                                    name="passwordConfirm"
                                    type="password"
                                    value={formData.passwordConfirm}
                                    onChange={handleChange}
                                    placeholder="Confirm your password"
                                    style={{
                                        width: '100%',
                                        padding: '0.8rem 1rem',
                                        fontSize: '0.95rem',
                                        fontFamily: 'inherit',
                                        border: `1.5px solid ${errors.passwordConfirm ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`,
                                        borderRadius: 8,
                                        background: 'rgba(30, 41, 59, 0.6)',
                                        boxSizing: 'border-box',
                                        transition: 'all 0.25s ease',
                                        color: 'rgba(203, 213, 225, 0.95)',
                                        backdropFilter: 'blur(8px)',
                                    }}
                                    onFocus={(e) => {
                                        if (!errors.passwordConfirm) {
                                            e.target.style.borderColor = 'rgba(0, 217, 255, 0.5)';
                                            e.target.style.background = 'rgba(30, 41, 59, 0.8)';
                                            e.target.style.boxShadow = '0 0 20px rgba(0, 217, 255, 0.1)';
                                        }
                                    }}
                                    onBlur={(e) => {
                                        e.target.style.borderColor = `${errors.passwordConfirm ? '#ff6b6b' : 'rgba(0, 217, 255, 0.2)'}`;
                                        e.target.style.background = 'rgba(30, 41, 59, 0.6)';
                                        e.target.style.boxShadow = 'none';
                                    }}
                                />
                                {errors.passwordConfirm && (
                                    <p style={{ fontSize: '0.75rem', color: '#ff6b6b', margin: '5px 0 0', fontWeight: 500 }}>
                                        {errors.passwordConfirm}
                                    </p>
                                )}
                            </div>

                            {/* Server error message */}
                            {serverError && (
                                <div
                                    style={{
                                        padding: '0.75rem 1rem',
                                        background: 'rgba(255, 107, 107, 0.1)',
                                        border: '1px solid rgba(255, 107, 107, 0.3)',
                                        borderRadius: 8,
                                        color: '#ff6b6b',
                                        fontSize: '0.85rem',
                                        marginBottom: 20,
                                        fontWeight: 500,
                                    }}
                                >
                                    {serverError}
                                </div>
                            )}

                            {/* Submit button */}
                            <button
                                type="submit"
                                disabled={submitting}
                                style={{
                                    width: '100%',
                                    padding: '1rem 2rem',
                                    background: submitting
                                        ? 'rgba(0, 217, 255, 0.2)'
                                        : 'linear-gradient(135deg, #00d9ff 0%, #0099cc 100%)',
                                    color: submitting ? 'rgba(0, 217, 255, 0.6)' : 'rgba(15, 20, 25, 0.95)',
                                    fontFamily: 'inherit',
                                    fontWeight: 700,
                                    fontSize: '0.95rem',
                                    letterSpacing: '-0.01em',
                                    border: 'none',
                                    borderRadius: 8,
                                    cursor: submitting ? 'default' : 'pointer',
                                    display: 'flex',
                                    alignItems: 'center',
                                    justifyContent: 'center',
                                    gap: 8,
                                    boxShadow: '0 8px 32px rgba(0, 217, 255, 0.3)',
                                    transition: 'all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94)',
                                    position: 'relative',
                                    overflow: 'hidden',
                                }}
                                onMouseEnter={(e) => {
                                    if (!submitting) {
                                        e.currentTarget.style.boxShadow = '0 12px 48px rgba(0, 217, 255, 0.4)';
                                        e.currentTarget.style.transform = 'translateY(-2px)';
                                    }
                                }}
                                onMouseLeave={(e) => {
                                    if (!submitting) {
                                        e.currentTarget.style.boxShadow = '0 8px 32px rgba(0, 217, 255, 0.3)';
                                        e.currentTarget.style.transform = 'translateY(0)';
                                    }
                                }}
                            >
                                {submitting ? (
                                    <>
                                        <span
                                            style={{
                                                display: 'flex',
                                                gap: 4,
                                                alignItems: 'center',
                                            }}
                                        >
                                            {[0, 160, 320].map((d) => (
                                                <span
                                                    key={d}
                                                    style={{
                                                        width: 4,
                                                        height: 4,
                                                        borderRadius: '50%',
                                                        background: 'rgba(0, 217, 255, 0.6)',
                                                        animation: 'sl-loading-dot 1.1s ease-in-out infinite',
                                                        animationDelay: `${d}ms`,
                                                    }}
                                                />
                                            ))}
                                        </span>
                                    </>
                                ) : (
                                    'Create account'
                                )}
                            </button>

                            {/* Sign in link */}
                            <p
                                style={{
                                    fontSize: '0.85rem',
                                    color: 'rgba(148, 163, 184, 0.8)',
                                    marginTop: 18,
                                    textAlign: 'center',
                                }}
                            >
                                Already have an account?{' '}
                                <a
                                    href="/"
                                    style={{
                                        color: '#00d9ff',
                                        fontWeight: 600,
                                        textDecoration: 'none',
                                        transition: 'color 0.2s ease',
                                    }}
                                    onMouseEnter={(e) => {
                                        e.target.style.color = 'rgba(0, 217, 255, 0.7)';
                                    }}
                                    onMouseLeave={(e) => {
                                        e.target.style.color = '#00d9ff';
                                    }}
                                >
                                    Sign in
                                </a>
                            </p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
}
