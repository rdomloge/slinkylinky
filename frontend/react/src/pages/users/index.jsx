import React, { useState, useEffect } from 'react';
import Layout from '@/components/layout/Layout';
import Loading from '@/components/Loading';
import { StyledButton } from '@/components/atoms/Button';
import Modal from '@/components/atoms/Modal';
import DisableUserConfirmModal from '@/components/DisableUserConfirmModal';
import TextInput from '@/components/atoms/TextInput';
import { useAuth } from '@/auth/AuthProvider';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { Navigate } from 'react-router-dom';

export default function UsersIndex() {
    const { user } = useAuth();
    const isGlobalAdmin = user?.roles?.includes('global_admin');
    const isTenantAdmin = user?.roles?.includes('tenant_admin');

    if (user && !isGlobalAdmin && !isTenantAdmin) {
        return <Navigate to="/" replace />;
    }

    const roleOptions = [
        { value: '', label: 'Default user (no role)' },
        { value: 'tenant_admin', label: 'Tenant admin' },
        ...(isGlobalAdmin ? [{ value: 'global_admin', label: 'Global admin' }] : []),
    ];

    const [users, setUsers] = useState(null);
    const [error, setError] = useState(null);
    const [orgId, setOrgId] = useState(null);
    const [organisations, setOrganisations] = useState(null);
    const [showNewModal, setShowNewModal] = useState(false);
    const [newFirstName, setNewFirstName] = useState('');
    const [newLastName, setNewLastName] = useState('');
    const [newEmail, setNewEmail] = useState('');
    const [newPassword, setNewPassword] = useState('');
    const [newRole, setNewRole] = useState('');
    const [creating, setCreating] = useState(false);
    const [createError, setCreateError] = useState(null);
    const [showDisableModal, setShowDisableModal] = useState(false);
    const [userToDisable, setUserToDisable] = useState(null);
    const [disabling, setDisabling] = useState(false);

    // Resolve the initial org to display
    useEffect(() => {
        if (!user) return;
        if (isGlobalAdmin) {
            fetchWithAuth('/.rest/organisations')
                .then(r => r?.ok ? r.json() : Promise.reject())
                .then(data => {
                    const orgs = data._embedded?.organisations || [];
                    setOrganisations(orgs);
                    // Default to caller's own org if they have one, else first in list
                    const initial = orgs.find(o => o.id === user.orgId) || orgs[0];
                    if (initial) setOrgId(initial.id);
                })
                .catch(() => setError('Could not load organisations'));
        } else {
            setOrgId(user.orgId);
        }
    }, [user]);

    // Load users when orgId is resolved
    useEffect(() => {
        if (!orgId) return;
        setUsers(null);
        setError(null);
        fetchWithAuth(`/.rest/keycloak/users?orgId=${orgId}`)
            .then(r => {
                if (r?.status === 503) throw new Error('Keycloak Admin API is not configured on this server');
                if (!r?.ok) throw new Error('Could not load users');
                return r.json();
            })
            .then(data => setUsers(data))
            .catch(e => setError(e.message));
    }, [orgId]);

    function openNewModal() {
        setNewFirstName('');
        setNewLastName('');
        setNewEmail('');
        setNewPassword('');
        setNewRole('');
        setCreateError(null);
        setShowNewModal(true);
    }

    function createUser() {
        setCreating(true);
        setCreateError(null);
        const username = newEmail.toLowerCase().trim();
        const body = {
            username,
            firstName: newFirstName.trim(),
            lastName: newLastName.trim(),
            email: newEmail.trim(),
            enabled: true,
            credentials: [{ type: 'password', value: newPassword, temporary: true }],
            attributes: { org_id: [orgId] },
            ...(newRole ? { role: newRole } : {}),
        };
        fetchWithAuth('/.rest/keycloak/users', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body),
        })
            .then(r => {
                if (!r?.ok) throw new Error('Failed to create user');
                setShowNewModal(false);
                // Reload user list
                setUsers(null);
                return fetchWithAuth(`/.rest/keycloak/users?orgId=${orgId}`);
            })
            .then(r => r?.json())
            .then(data => setUsers(data))
            .catch(e => setCreateError(e.message))
            .finally(() => setCreating(false));
    }

    function openDisableModal(userId, username) {
        setUserToDisable({ id: userId, username });
        setShowDisableModal(true);
    }

    function confirmDisableUser() {
        if (!userToDisable) return;
        setDisabling(true);
        fetchWithAuth(`/.rest/keycloak/users/${userToDisable.id}`, { method: 'DELETE' })
            .then(r => {
                if (!r?.ok) throw new Error('Failed to disable user');
                setUsers(prev => prev.map(u => u.id === userToDisable.id ? { ...u, enabled: false } : u));
                setShowDisableModal(false);
            })
            .catch(e => setError(e.message))
            .finally(() => setDisabling(false));
    }

    const canCreate = isGlobalAdmin || isTenantAdmin;
    const selectedOrg = organisations?.find(o => o.id === orgId);

    return (
        <Layout
            pagetitle="Users"
            headerTitle={
                <>
                    Users
                    {users && <span className="font-normal text-slate-400 ml-2">({users.length})</span>}
                </>
            }
            headerActions={
                canCreate && orgId ? (
                    <StyledButton label="New user" type="primary" extraClass="!m-0" submitHandler={openNewModal} enabled />
                ) : null
            }
        >
            {/* Org picker for global_admin */}
            {isGlobalAdmin && organisations && (
                <div className="px-6 pb-4 flex items-center gap-3">
                    <span className="text-sm text-slate-500">Organisation</span>
                    <select
                        className="text-sm border border-slate-200 rounded-lg px-3 py-1.5 bg-white text-slate-800 focus:outline-none focus:ring-2 focus:ring-indigo-300"
                        value={orgId || ''}
                        onChange={e => setOrgId(e.target.value)}
                    >
                        {organisations.map(o => (
                            <option key={o.id} value={o.id}>{o.name}</option>
                        ))}
                    </select>
                </div>
            )}

            {!isGlobalAdmin && orgId === null && (
                <div className="px-6 py-4 text-sm text-amber-600 bg-amber-50 border border-amber-200 rounded-lg mx-6">
                    Your account has no organisation assigned. Contact a global admin.
                </div>
            )}

            {users ? (
                <div className="px-6 pb-6">
                    {users.length === 0 ? (
                        <p className="text-slate-400 text-sm py-4">No users found for this organisation.</p>
                    ) : (
                        <table className="w-full text-sm">
                            <thead>
                                <tr className="border-b border-slate-200 text-left text-slate-500">
                                    <th className="py-2 pr-4 font-medium">Name</th>
                                    <th className="py-2 pr-4 font-medium">Username / Email</th>
                                    <th className="py-2 pr-4 font-medium">Status</th>
                                    {isGlobalAdmin && <th className="py-2 font-medium"/>}
                                </tr>
                            </thead>
                            <tbody>
                                {users.map(u => (
                                    <tr key={u.id} className="border-b border-slate-100">
                                        <td className="py-2 pr-4 font-medium text-slate-800">
                                            {[u.firstName, u.lastName].filter(Boolean).join(' ') || '—'}
                                        </td>
                                        <td className="py-2 pr-4 text-slate-500">
                                            <span className="font-mono text-xs block">{u.username}</span>
                                            {u.email && u.email !== u.username && (
                                                <span className="text-xs text-slate-400">{u.email}</span>
                                            )}
                                        </td>
                                        <td className="py-2 pr-4">
                                            <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${u.enabled ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500'}`}>
                                                {u.enabled ? 'Active' : 'Disabled'}
                                            </span>
                                        </td>
                                        {isGlobalAdmin && (
                                            <td className="py-2 text-right">
                                                {u.enabled && (
                                                    <button
                                                        onClick={() => openDisableModal(u.id, u.username)}
                                                        className="text-xs text-red-500 hover:text-red-700 hover:underline"
                                                    >
                                                        Disable
                                                    </button>
                                                )}
                                            </td>
                                        )}
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    )}
                </div>
            ) : (
                <Loading error={error} />
            )}

            {showNewModal && (
                <Modal title="New user" dismissHandler={() => setShowNewModal(false)}>
                    <div className="flex flex-col gap-3 p-1">
                        {selectedOrg && (
                            <p className="text-xs text-slate-400">
                                Organisation: <span className="font-medium text-slate-600">{selectedOrg.name}</span>
                            </p>
                        )}
                        <div className="flex gap-3">
                            <div className="flex-1">
                                <TextInput label="First name" binding={newFirstName} changeHandler={setNewFirstName} />
                            </div>
                            <div className="flex-1">
                                <TextInput label="Last name" binding={newLastName} changeHandler={setNewLastName} />
                            </div>
                        </div>
                        <TextInput label="Email (used as username)" binding={newEmail} changeHandler={setNewEmail} />
                        <TextInput label="Temporary password" binding={newPassword} changeHandler={setNewPassword} />
                        <div className="flex flex-col gap-1">
                            <label className="text-sm font-medium text-slate-700">Role</label>
                            <select
                                className="text-sm border border-slate-200 rounded-lg px-3 py-1.5 bg-white text-slate-800 focus:outline-none focus:ring-2 focus:ring-indigo-300"
                                value={newRole}
                                onChange={e => setNewRole(e.target.value)}
                            >
                                {roleOptions.map(o => (
                                    <option key={o.value} value={o.value}>{o.label}</option>
                                ))}
                            </select>
                        </div>
                        <p className="text-xs text-slate-400">The user will be prompted to change their password on first login.</p>
                        {createError && <p className="text-xs text-red-600">{createError}</p>}
                        <div className="flex justify-end pt-1">
                            <StyledButton
                                label={creating ? 'Creating…' : 'Create'}
                                type="primary"
                                submitHandler={createUser}
                                enabled={!creating && !!newEmail && !!newPassword}
                            />
                        </div>
                    </div>
                </Modal>
            )}

            {showDisableModal && userToDisable && (
                <DisableUserConfirmModal
                    username={userToDisable.username}
                    isLoading={disabling}
                    onConfirm={confirmDisableUser}
                    onDismiss={() => {
                        setShowDisableModal(false);
                        setUserToDisable(null);
                    }}
                />
            )}
        </Layout>
    );
}
