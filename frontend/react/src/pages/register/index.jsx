import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Logo from '@/assets/logo.png';

const ConnectionNodes = () => (
    <svg
        style={{
            position: 'absolute',
            inset: 0,
            width: '100%',
            height: '100%',
            pointerEvents: 'none',
        }}
        viewBox="0 0 1200 800"
        preserveAspectRatio="xMidYMid slice"
    >
        <defs>
            <linearGradient id="nodeGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stopColor="rgba(109, 184, 157, 0.4)" />
                <stop offset="100%" stopColor="rgba(212, 165, 116, 0.3)" />
            </linearGradient>
        </defs>
        <g opacity="0.15" stroke="url(#nodeGradient)" strokeWidth="0.5">
            <line x1="100" y1="100" x2="400" y2="300" />
            <line x1="400" y1="300" x2="800" y2="200" />
            <line x1="800" y1="200" x2="1000" y2="500" />
            <line x1="1000" y1="500" x2="600" y2="700" />
            <line x1="600" y1="700" x2="200" y2="600" />
            <line x1="200" y1="600" x2="100" y2="100" />
            <line x1="400" y1="300" x2="600" y2="700" />
            <line x1="800" y1="200" x2="200" y2="600" />
        </g>
        <g fill="rgba(109, 184, 157, 0.5)">
            <circle cx="100" cy="100" r="2.5" />
            <circle cx="400" cy="300" r="2" />
            <circle cx="800" cy="200" r="2.5" />
            <circle cx="1000" cy="500" r="2" />
            <circle cx="600" cy="700" r="2" />
            <circle cx="200" cy="600" r="2.5" />
        </g>
    </svg>
);

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
                background: 'linear-gradient(135deg, #fafbfc 0%, #f5f5f5 50%, #efefef 100%)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                overflow: 'auto',
                fontFamily: "'Space Grotesk', sans-serif",
                zIndex: 1,
            }}
        >
            <ConnectionNodes style={{ zIndex: 0 }} />

            {/* Soft ambient nodes */}
            <div
                style={{
                    position: 'absolute',
                    top: '10%',
                    left: '8%',
                    width: 500,
                    height: 500,
                    background: 'radial-gradient(circle, rgba(109, 184, 157, 0.12) 0%, transparent 70%)',
                    borderRadius: '50%',
                    filter: 'blur(60px)',
                    animation: 'sl-node-drift-a 22s ease-in-out infinite',
                    pointerEvents: 'none',
                }}
            />
            <div
                style={{
                    position: 'absolute',
                    bottom: '12%',
                    right: '10%',
                    width: 450,
                    height: 450,
                    background: 'radial-gradient(circle, rgba(212, 165, 116, 0.08) 0%, transparent 70%)',
                    borderRadius: '50%',
                    filter: 'blur(56px)',
                    animation: 'sl-node-drift-b 26s ease-in-out infinite',
                    pointerEvents: 'none',
                }}
            />
            <div
                style={{
                    position: 'absolute',
                    top: '45%',
                    right: '8%',
                    width: 380,
                    height: 380,
                    background: 'radial-gradient(circle, rgba(168, 157, 189, 0.1) 0%, transparent 70%)',
                    borderRadius: '50%',
                    filter: 'blur(50px)',
                    animation: 'sl-node-drift-c 20s ease-in-out infinite',
                    pointerEvents: 'none',
                }}
            />

            {/* Fine dot grid */}
            <div
                style={{
                    position: 'absolute',
                    inset: 0,
                    backgroundImage: 'radial-gradient(circle, rgba(0,0,0,0.04) 0.5px, transparent 0.5px)',
                    backgroundSize: '40px 40px',
                    pointerEvents: 'none',
                    zIndex: 0,
                }}
            />

            {/* Main content */}
            <div
                style={{
                    position: 'relative',
                    zIndex: 20,
                    width: '100%',
                    maxWidth: 420,
                    padding: '2rem',
                }}
            >
                {/* Logo + wordmark */}
                <div
                    style={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: 14,
                        marginBottom: 40,
                        animation: 'sl-fade-up 0.55s ease-out 0.1s both',
                    }}
                >
                    <img
                        src={Logo}
                        width={Math.round(439 / 8)}
                        height={Math.round(498 / 8)}
                        alt="SlinkyLinky"
                        style={{ opacity: 0.75 }}
                    />
                    <span
                        style={{
                            fontSize: '1.8rem',
                            fontWeight: 700,
                            color: 'var(--text-primary)',
                            letterSpacing: '-0.02em',
                            lineHeight: 1,
                        }}
                    >
                        Slinky<span style={{ color: '#a89dbd' }}>Linky</span>
                    </span>
                </div>

                {/* Headline */}
                <h1
                    style={{
                        fontSize: '2rem',
                        fontWeight: 800,
                        color: 'var(--text-primary)',
                        letterSpacing: '-0.045em',
                        lineHeight: 1.1,
                        margin: '0 0 12px',
                        animation: 'sl-fade-up 0.55s ease-out 0.15s both',
                    }}
                >
                    Create an account
                </h1>

                {/* Subheading */}
                <p
                    style={{
                        color: 'var(--text-secondary)',
                        fontSize: '0.95rem',
                        lineHeight: 1.5,
                        margin: '0 0 32px',
                        animation: 'sl-fade-up 0.55s ease-out 0.2s both',
                        fontWeight: 400,
                    }}
                >
                    Join SlinkyLinky to manage your SEO link building strategy.
                </p>

                {/* Form */}
                <form onSubmit={handleSubmit} noValidate style={{ animation: 'sl-fade-up 0.55s ease-out 0.25s both' }}>
                    {/* First name field */}
                    <div style={{ marginBottom: 20 }}>
                        <label
                            htmlFor="firstName"
                            style={{
                                display: 'block',
                                fontSize: '0.85rem',
                                fontWeight: 600,
                                color: 'var(--text-primary)',
                                marginBottom: 6,
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
                                padding: '0.75rem 1rem',
                                fontSize: '0.95rem',
                                fontFamily: "'Space Grotesk', sans-serif",
                                border: `2px solid ${errors.firstName ? '#d32f2f' : '#e8e8e8'}`,
                                borderRadius: 8,
                                background: 'white',
                                boxSizing: 'border-box',
                                transition: 'border-color 0.2s ease',
                                color: '#2c3e50',
                            }}
                        />
                        {errors.firstName && (
                            <p style={{ fontSize: '0.8rem', color: '#d32f2f', margin: '4px 0 0' }}>
                                {errors.firstName}
                            </p>
                        )}
                    </div>

                    {/* Last name field */}
                    <div style={{ marginBottom: 20 }}>
                        <label
                            htmlFor="lastName"
                            style={{
                                display: 'block',
                                fontSize: '0.85rem',
                                fontWeight: 600,
                                color: 'var(--text-primary)',
                                marginBottom: 6,
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
                                padding: '0.75rem 1rem',
                                fontSize: '0.95rem',
                                fontFamily: "'Space Grotesk', sans-serif",
                                border: `2px solid ${errors.lastName ? '#d32f2f' : '#e8e8e8'}`,
                                borderRadius: 8,
                                background: 'white',
                                boxSizing: 'border-box',
                                transition: 'border-color 0.2s ease',
                                color: '#2c3e50',
                            }}
                        />
                        {errors.lastName && (
                            <p style={{ fontSize: '0.8rem', color: '#d32f2f', margin: '4px 0 0' }}>
                                {errors.lastName}
                            </p>
                        )}
                    </div>

                    {/* Email field */}
                    <div style={{ marginBottom: 20 }}>
                        <label
                            htmlFor="email"
                            style={{
                                display: 'block',
                                fontSize: '0.85rem',
                                fontWeight: 600,
                                color: 'var(--text-primary)',
                                marginBottom: 6,
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
                                padding: '0.75rem 1rem',
                                fontSize: '0.95rem',
                                fontFamily: "'Space Grotesk', sans-serif",
                                border: `2px solid ${errors.email ? '#d32f2f' : '#e8e8e8'}`,
                                borderRadius: 8,
                                background: 'white',
                                boxSizing: 'border-box',
                                transition: 'border-color 0.2s ease',
                                color: '#2c3e50',
                            }}
                        />
                        {errors.email && (
                            <p style={{ fontSize: '0.8rem', color: '#d32f2f', margin: '4px 0 0' }}>
                                {errors.email}
                            </p>
                        )}
                    </div>

                    {/* Company name field */}
                    <div style={{ marginBottom: 20 }}>
                        <label
                            htmlFor="companyName"
                            style={{
                                display: 'block',
                                fontSize: '0.85rem',
                                fontWeight: 600,
                                color: 'var(--text-primary)',
                                marginBottom: 6,
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
                                padding: '0.75rem 1rem',
                                fontSize: '0.95rem',
                                fontFamily: "'Space Grotesk', sans-serif",
                                border: `2px solid ${errors.companyName ? '#d32f2f' : '#e8e8e8'}`,
                                borderRadius: 8,
                                background: 'white',
                                boxSizing: 'border-box',
                                transition: 'border-color 0.2s ease',
                                color: '#2c3e50',
                            }}
                        />
                        {errors.companyName && (
                            <p style={{ fontSize: '0.8rem', color: '#d32f2f', margin: '4px 0 0' }}>
                                {errors.companyName}
                            </p>
                        )}
                    </div>

                    {/* Password field */}
                    <div style={{ marginBottom: 20 }}>
                        <label
                            htmlFor="password"
                            style={{
                                display: 'block',
                                fontSize: '0.85rem',
                                fontWeight: 600,
                                color: 'var(--text-primary)',
                                marginBottom: 6,
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
                                padding: '0.75rem 1rem',
                                fontSize: '0.95rem',
                                fontFamily: "'Space Grotesk', sans-serif",
                                border: `2px solid ${errors.password ? '#d32f2f' : '#e8e8e8'}`,
                                borderRadius: 8,
                                background: 'white',
                                boxSizing: 'border-box',
                                transition: 'border-color 0.2s ease',
                                color: '#2c3e50',
                            }}
                        />
                        {errors.password && (
                            <p style={{ fontSize: '0.8rem', color: '#d32f2f', margin: '4px 0 0' }}>
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
                                fontSize: '0.85rem',
                                fontWeight: 600,
                                color: 'var(--text-primary)',
                                marginBottom: 6,
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
                                padding: '0.75rem 1rem',
                                fontSize: '0.95rem',
                                fontFamily: "'Space Grotesk', sans-serif",
                                border: `2px solid ${errors.passwordConfirm ? '#d32f2f' : '#e8e8e8'}`,
                                borderRadius: 8,
                                background: 'white',
                                boxSizing: 'border-box',
                                transition: 'border-color 0.2s ease',
                                color: '#2c3e50',
                            }}
                        />
                        {errors.passwordConfirm && (
                            <p style={{ fontSize: '0.8rem', color: '#d32f2f', margin: '4px 0 0' }}>
                                {errors.passwordConfirm}
                            </p>
                        )}
                    </div>

                    {/* Server error message */}
                    {serverError && (
                        <div
                            style={{
                                padding: '0.75rem 1rem',
                                background: 'rgba(211, 47, 47, 0.1)',
                                border: '1px solid rgba(211, 47, 47, 0.3)',
                                borderRadius: 8,
                                color: '#d32f2f',
                                fontSize: '0.85rem',
                                marginBottom: 20,
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
                            padding: '0.9rem 2rem',
                            background: submitting
                                ? 'rgba(168, 157, 189, 0.5)'
                                : 'linear-gradient(135deg, #a89dbd 0%, #8dcbb3 100%)',
                            color: 'white',
                            fontFamily: "'Space Grotesk', sans-serif",
                            fontWeight: 600,
                            fontSize: '0.95rem',
                            letterSpacing: '-0.01em',
                            border: 'none',
                            borderRadius: 8,
                            cursor: submitting ? 'default' : 'pointer',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            gap: 8,
                            boxShadow: '0 4px 16px rgba(168, 157, 189, 0.25)',
                            transition: 'box-shadow 0.3s ease, transform 0.2s ease',
                            position: 'relative',
                            overflow: 'hidden',
                        }}
                        onMouseEnter={(e) => {
                            if (!submitting) {
                                e.currentTarget.style.boxShadow = '0 8px 28px rgba(168, 157, 189, 0.35)';
                                e.currentTarget.style.transform = 'translateY(-1px)';
                            }
                        }}
                        onMouseLeave={(e) => {
                            if (!submitting) {
                                e.currentTarget.style.boxShadow = '0 4px 16px rgba(168, 157, 189, 0.25)';
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
                                                background: 'rgba(255,255,255,0.9)',
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
                            color: 'var(--text-secondary)',
                            marginTop: 16,
                            textAlign: 'center',
                        }}
                    >
                        Already have an account?{' '}
                        <a
                            href="/"
                            style={{ color: '#a89dbd', fontWeight: 600, textDecoration: 'none' }}
                        >
                            Sign in
                        </a>
                    </p>
                </form>
            </div>
        </div>
    );
}
