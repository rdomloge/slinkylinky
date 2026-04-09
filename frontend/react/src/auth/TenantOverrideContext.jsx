import React, { createContext, useContext, useState, useCallback } from 'react';

const TenantOverrideContext = createContext(null);

export function TenantOverrideProvider({ children }) {
    const [overrideOrgId, setOverrideOrgIdState] = useState(
        () => sessionStorage.getItem('sl_tenant_override') || null
    );

    const setOverrideOrgId = useCallback((orgId) => {
        if (orgId) {
            sessionStorage.setItem('sl_tenant_override', orgId);
        } else {
            sessionStorage.removeItem('sl_tenant_override');
        }
        setOverrideOrgIdState(orgId);
    }, []);

    return (
        <TenantOverrideContext.Provider value={{ overrideOrgId, setOverrideOrgId }}>
            {children}
        </TenantOverrideContext.Provider>
    );
}

export function useTenantOverride() {
    const ctx = useContext(TenantOverrideContext);
    if (!ctx) throw new Error('useTenantOverride must be used within TenantOverrideProvider');
    return ctx;
}

export function getTenantOverride() {
    return sessionStorage.getItem('sl_tenant_override') || null;
}
