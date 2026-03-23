import '@/styles/globals.css'
import CategoriesCard from '@/components/CategoriesCard'
import AnchorIcon from '@/assets/anchor.svg'
import CalendarIcon from '@/assets/calendar.svg'
import LinkIcon from '@/assets/link.svg'
import DaIcon from '@/assets/authority.svg'
import LSLogo from '@/assets/linksync-logo.png'
import SLLogo from '@/assets/logo.png'
import NiceDate from './atoms/DateTime'
import WordCountIcon from '@/assets/text-word-count.svg'
import { Link } from 'react-router-dom'
import { SessionBlock, StyledButton } from './atoms/Button'
import { useState } from 'react'
import Modal from './atoms/Modal'
import { useAuth } from '@/auth/AuthProvider'
import { addProtocol } from './Util'
import { fetchWithAuth } from '@/utils/fetchWithAuth'

export default function DemandCard({demand, fullfilable=false, editable=false, id, deleteCascader, deletable=false, editHandler}) {

    const [showDeleteModal, setShowDeleteModal] = useState(false)
    const { user } = useAuth();

    function deleteHandler() {
        setShowDeleteModal(false)
        fetchWithAuth('/.rest/demandsupport/delete?demandId='+demand.id, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                'user': user.email
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
        <div className="card list-card" id={id}>

            {/* Header: name + actions */}
            <div className="flex items-start justify-between gap-2 mb-3">
                <div className="text-base font-semibold text-gray-900 leading-snug">{demand.name}</div>
                <SessionBlock>
                    <div className="flex items-center gap-3 shrink-0 text-sm">
                        {fullfilable &&
                            <Link to={'/supplier/search/'+demand.id} rel='nofollow'>
                                <span className="font-semibold text-blue-600 hover:text-blue-800">Fulfil</span>
                            </Link>
                        }
                        {editable && (
                            editHandler
                                ? <StyledButton label='Edit' type='primary' submitHandler={() => editHandler(demand)} isText={true}/>
                                : <Link to={'/demand/'+demand.id} rel='nofollow'>
                                    <span className="text-gray-400 hover:text-gray-700">Edit</span>
                                  </Link>
                        )}
                        {deletable &&
                            <StyledButton label='Delete' type='risky' submitHandler={() => setShowDeleteModal(true)} isText={true}/>
                        }
                    </div>
                </SessionBlock>
            </div>

            {/* URL + Anchor text */}
            <div className="space-y-1 mb-3">
                <Link to={addProtocol(demand.url)} target='_blank' rel='nofollow'
                    className="flex items-center gap-2 text-sm text-blue-600 hover:underline">
                    <img src={LinkIcon} alt="link" width={13} height={13} className="shrink-0 opacity-70"/>
                    <span className="truncate">{demand.url}</span>
                </Link>
                <div className="flex items-center gap-2 text-sm text-gray-500">
                    <img src={AnchorIcon} alt="anchor" width={13} height={13} className="shrink-0 opacity-60"/>
                    <span className="truncate">{demand.anchorText}</span>
                </div>
            </div>

            {/* Stat chips */}
            <div className="flex items-center flex-wrap gap-2 mb-3">
                <span className="inline-flex items-center gap-1.5 bg-blue-50 text-blue-700 text-xs font-semibold px-2.5 py-1 rounded-full">
                    <img src={DaIcon} alt="DA" width={11} height={11}/>
                    DA {demand.daNeeded}
                </span>
                <span className="inline-flex items-center gap-1.5 bg-gray-100 text-gray-600 text-xs font-medium px-2.5 py-1 rounded-full">
                    <img src={WordCountIcon} alt="words" width={12} height={12}/>
                    {demand.wordCount} words
                </span>
            </div>

            {/* Categories */}
            <CategoriesCard categories={demand.categories}/>

            {/* Footer: date, creator, source logo */}
            <div className="flex items-center justify-between mt-3 pt-3 border-t border-gray-100">
                <div className="flex items-center gap-1.5 text-xs text-gray-400 min-w-0">
                    <img src={CalendarIcon} alt="calendar" width={12} height={12} className="shrink-0"/>
                    <NiceDate isostring={demand.requested}/>
                    <span className="mx-0.5">·</span>
                    <span className="truncate">{demand.createdBy}</span>
                </div>
                <div className="shrink-0 ml-2">
                    {'LinkSync' === demand.source && <img src={LSLogo} alt="LinkSync" className="h-4 w-auto opacity-40"/>}
                    {'SlinkyLinky' === demand.source && <img src={SLLogo} alt="SlinkyLinky" className="h-4 w-auto opacity-40"/>}
                </div>
            </div>

            {showDeleteModal &&
                <Modal title='Delete demand' dismissHandler={() => setShowDeleteModal(false)}>
                    <p>Are you sure you want to delete this demand?</p>
                    <p className='font-bold text-center py-2'>&apos;{demand.name}&apos;</p>
                    <p>Created by {demand.createdBy}, requested on {new Date(demand.requested).toLocaleDateString()}</p>
                    <p className='text-red-500 text-center py-2'>This action cannot be undone.</p>
                    <div className='flex justify-end'>
                        <StyledButton label='Delete' type='risky' submitHandler={deleteHandler}/>
                    </div>
                </Modal>
            }
        </div>
    );
}
