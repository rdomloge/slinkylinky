import '@/styles/globals.css'
import CategoriesCard from '@/components/CategoriesCard'
import AnchorIcon from '@/assets/anchor.svg'
import CalendarIcon from '@/assets/calendar.svg'
import LinkIcon from '@/assets/link.svg'
import LSLogo from '@/assets/linksync-logo.png'
import SLLogo from '@/assets/logo.png'
import NiceDate from './atoms/DateTime'
import WordCountIcon from '@/assets/text-word-count.svg'
import { Link } from 'react-router-dom'
import { SessionBlock } from './atoms/Button'
import { useState } from 'react'
import Modal from './atoms/Modal'
import { addProtocol } from './Util'
import { fetchWithAuth } from '@/utils/fetchWithAuth'

export default function DemandCard({demand, fullfilable=false, editable=false, id, deleteCascader, deletable=false, editHandler}) {
    const [showDeleteModal, setShowDeleteModal] = useState(false)
    const isFulfilled = demand.status === 'fulfilled' || demand.fulfilled === true || demand.satisfied === true
    const demandTone = isFulfilled ? 'good' : 'demand'

    function deleteHandler() {
        setShowDeleteModal(false)
        fetchWithAuth('/.rest/demandsupport/delete?demandId=' + demand.id, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({id: demand.id})
        })
        .then(res => {
            if (res.ok) {
                deleteCascader(demand)
            }
        })
    }

    return (
        <div className="card list-card demand-card" id={id}>
            <div className="flex items-start gap-3 mb-4">
                <span className={`status-dot ${isFulfilled ? 'status-dot-good' : 'status-dot-demand'}`} />
                <div className="flex-1 min-w-0">
                    <div className="flex flex-wrap items-center gap-2 mb-2">
                        <span className="entity-badge entity-badge-demand">Demand</span>
                        <span className={`status-chip ${isFulfilled ? 'status-chip-good' : 'status-chip-demand'}`}>
                            {isFulfilled ? 'Fulfilled' : 'Open'}
                        </span>
                    </div>
                    <h3 className="card-title">{demand.name}</h3>
                </div>
                <SessionBlock>
                    <div className="flex items-center gap-3 shrink-0">
                        {fullfilable &&
                            <Link to={'/supplier/search/' + demand.id} rel='nofollow' className="card-filled-action card-filled-action-demand">
                                Fulfil
                            </Link>
                        }
                        {editable && (
                            editHandler
                                ? <button type="button" className="card-action-link card-action-link-muted" onClick={() => editHandler(demand)}>Edit</button>
                                : <Link to={'/demand/' + demand.id} rel='nofollow' className="card-action-link card-action-link-muted">Edit</Link>
                        )}
                        {deletable &&
                            <button type="button" className="card-action-link card-action-link-danger" onClick={() => setShowDeleteModal(true)}>
                                Delete
                            </button>
                        }
                    </div>
                </SessionBlock>
            </div>

            <div className="card-mono-row">
                <img src={LinkIcon} alt="link" width={13} height={13} className="shrink-0 opacity-60"/>
                <Link
                    to={addProtocol(demand.url)}
                    target='_blank'
                    rel='nofollow'
                    className="truncate hover:underline"
                    style={{ color: 'var(--demand-color)' }}
                >
                    {demand.url}
                </Link>
            </div>

            {demand.anchorText && (
                <div className="card-anchor-row">
                    <img src={AnchorIcon} alt="anchor" width={13} height={13} className="shrink-0 opacity-60"/>
                    <span className="truncate">{demand.anchorText}</span>
                </div>
            )}

            <div className="flex flex-wrap gap-2 mb-4">
                <span className={`metric-pill ${demand.daNeeded >= 40 ? 'metric-pill-good' : 'metric-pill-demand'}`}>
                    <span className="metric-pill-label">DA</span>
                    <span>{demand.daNeeded}+</span>
                </span>
                {demand.wordCount &&
                    <span className="metric-pill metric-pill-neutral">
                        <img src={WordCountIcon} alt="words" width={12} height={12}/>
                        <span>{demand.wordCount}w</span>
                    </span>
                }
            </div>

            <div className="mb-4">
                <CategoriesCard categories={demand.categories}/>
            </div>

            <div className="card-footer">
                <span className="inline-flex items-center gap-1.5 min-w-0">
                    <img src={CalendarIcon} alt="calendar" width={12} height={12} className="shrink-0"/>
                    <NiceDate isostring={demand.requested}/>
                </span>
                <span>·</span>
                <span className="font-mono-data truncate">{demand.createdBy}</span>
                <div className="flex-1" />
                <div className="shrink-0 ml-2">
                    {'LinkSync' === demand.source && <img src={LSLogo} alt="LinkSync" className="h-4 w-auto opacity-30"/>}
                    {'SlinkyLinky' === demand.source && <img src={SLLogo} alt="SlinkyLinky" className="h-4 w-auto opacity-30"/>}
                </div>
            </div>

            {showDeleteModal &&
                <Modal title='Delete demand' dismissHandler={() => setShowDeleteModal(false)}>
                    <p className="text-slate-600">Are you sure you want to delete this demand?</p>
                    <div className="rounded-lg px-4 py-3 text-sm" style={{background: 'var(--demand-bg)', border: '1px solid var(--demand-border)'}}>
                        <p className="font-semibold text-slate-800">{demand.name}</p>
                        <p className="text-slate-500 text-xs mt-0.5">Created by {demand.createdBy} · {new Date(demand.requested).toLocaleDateString()}</p>
                    </div>
                    <div className="flex items-center gap-2 rounded-lg px-4 py-3 bg-red-50 border border-red-100">
                        <svg className="w-4 h-4 text-red-500 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"/>
                        </svg>
                        <span className="text-red-600 text-sm font-medium">This action cannot be undone.</span>
                    </div>
                    <div className="flex justify-end gap-2 pt-1">
                        <button onClick={() => setShowDeleteModal(false)}
                            className="px-4 py-2 rounded-lg text-sm font-medium text-slate-600 hover:bg-slate-100 transition-colors">
                            Cancel
                        </button>
                        <button onClick={deleteHandler}
                            className="px-4 py-2 rounded-lg text-sm font-semibold text-white bg-red-600 hover:bg-red-700 transition-colors">
                            Delete
                        </button>
                    </div>
                </Modal>
            }
        </div>
    );
}
