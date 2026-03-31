<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in — SlinkyLinky</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css">
</head>
<body>

    <!-- Animated background orbs -->
    <div class="sl-bg">
        <div class="sl-orb sl-orb-1"></div>
        <div class="sl-orb sl-orb-2"></div>
        <div class="sl-orb sl-orb-3"></div>
    </div>

    <div class="sl-page">
        <div class="sl-card">

            <!-- Brand header -->
            <div class="sl-brand">
                <svg class="sl-logo-icon" width="26" height="26" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71" stroke="#a78bfa" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <span class="sl-wordmark">Slinky<span class="sl-accent">Linky</span></span>
            </div>

            <h1 class="sl-title">Welcome back</h1>
            <p class="sl-subtitle">Sign in to your workspace</p>

            <!-- Error / info message -->
            <#if message?has_content>
            <div class="sl-message sl-message-${message.type}">
                ${message.summary}
            </div>
            </#if>

            <!-- Login form -->
            <form action="${url.loginAction}" method="post" class="sl-form">

                <div class="sl-field">
                    <label class="sl-label" for="username">Email or username</label>
                    <input
                        class="sl-input"
                        type="text"
                        id="username"
                        name="username"
                        value="${(login.username!'')}"
                        autocomplete="username email"
                        autofocus
                        tabindex="1"
                    />
                </div>

                <div class="sl-field">
                    <div class="sl-label-row">
                        <label class="sl-label" for="password">Password</label>
                        <#if realm.resetPasswordAllowed>
                        <a class="sl-forgot" href="${url.loginResetCredentialsUrl}" tabindex="5">Forgot password?</a>
                        </#if>
                    </div>
                    <input
                        class="sl-input"
                        type="password"
                        id="password"
                        name="password"
                        autocomplete="current-password"
                        tabindex="2"
                    />
                </div>

                <#if realm.rememberMe>
                <div class="sl-remember">
                    <input
                        class="sl-checkbox"
                        type="checkbox"
                        id="rememberMe"
                        name="rememberMe"
                        tabindex="3"
                        <#if login.rememberMe?? && login.rememberMe>checked</#if>
                    />
                    <label for="rememberMe">Keep me signed in</label>
                </div>
                </#if>

                <button class="sl-btn" type="submit" tabindex="4">
                    <span>Continue</span>
                    <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                        <path d="M2 7.5h11M9 3l4 4.5-4 4.5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </button>

            </form>
        </div>
    </div>

</body>
</html>
