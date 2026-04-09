import React, { useState, useEffect } from 'react';
import Layout from '@/components/layout/Layout';
import Loading from '@/components/Loading';
import { StyledButton } from '@/components/atoms/Button';
import Modal from '@/components/atoms/Modal';
import TextInput from '@/components/atoms/TextInput';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function OrganisationsIndex() {
    const [organisations, setOrganisations] = useState(null);
    const [error, setError] = useState(null);
    const [showNewModal, setShowNewModal] = useState(false);
    const [newName, setNewName] = useState('');
    const [newSlug, setNewSlug] = useState('');

    useEffect(() => {
        fetchWithAuth('/.rest/organisations')
            .then(r => r?.ok ? r.json() : Promise.reject(r))
            .then(data => setOrganisations(data._embedded?.organisations || []))
            .catch(() => setError('Could not load organisations'));
    }, []);

    function createOrganisation() {
        fetchWithAuth('/.rest/organisations', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name: newName, slug: newSlug, active: true }),
        })
            .then(r => {
                if (!r?.ok) throw new Error('Create failed');
                return r.json();
            })
            .then(org => {
                setOrganisations(prev => [...(prev || []), org]);
                setShowNewModal(false);
                setNewName('');
                setNewSlug('');
            })
            .catch(() => setError('Failed to create organisation'));
    }

    return (
        <Layout
            pagetitle="Organisations"
            headerTitle={<>Organisations {organisations && <span className="font-normal text-slate-400">({organisations.length})</span>}</>}
            headerActions={
                <StyledButton label="New" type="primary" extraClass="!m-0" submitHandler={() => setShowNewModal(true)} enabled />
            }
        >
            {organisations ? (
                <div className="px-6 pb-6">
                    <table className="w-full text-sm">
                        <thead>
                            <tr className="border-b border-slate-200 text-left text-slate-500">
                                <th className="py-2 pr-4 font-medium">Name</th>
                                <th className="py-2 pr-4 font-medium">Slug</th>
                                <th className="py-2 font-medium">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {organisations.map((org, i) => (
                                <tr key={i} className="border-b border-slate-100">
                                    <td className="py-2 pr-4 font-medium text-slate-800">{org.name}</td>
                                    <td className="py-2 pr-4 text-slate-500 font-mono text-xs">{org.slug}</td>
                                    <td className="py-2">
                                        <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${org.active ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500'}`}>
                                            {org.active ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            ) : (
                <Loading error={error} />
            )}

            {showNewModal && (
                <Modal title="New Organisation" dismissHandler={() => setShowNewModal(false)}>
                    <div className="flex flex-col gap-3 p-4">
                        <TextInput label="Name" value={newName} changeHandler={setNewName} />
                        <TextInput label="Slug" value={newSlug} changeHandler={setNewSlug} />
                        <StyledButton label="Create" type="primary" submitHandler={createOrganisation} enabled={!!newName && !!newSlug} />
                    </div>
                </Modal>
            )}
        </Layout>
    );
}
