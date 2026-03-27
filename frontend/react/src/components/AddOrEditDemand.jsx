import React, {useState} from 'react'
import { useAuth } from "@/auth/AuthProvider";
import TextInput from '@/components/atoms/TextInput';
import NumberInput from '@/components/atoms/NumberInput';
import DemandSiteFinder from './DemandSiteFinder';
import Loading from './Loading';
import CategoriesCard from './CategoriesCard';
import { StyledButton } from './atoms/Button';
import { fixForPosting } from './CategoryUtil';
import ErrorMessage from './atoms/Messages';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function AddOrEditDemand({demand, successHandler}) {

    const { user } = useAuth();
    const [searchTerm, setSearchTerm]           = useState()
    const [demandsite, setDemandsite]           = useState()
    const [editMode]                            = useState(demand.id ? true : false)

    const [demandName, setDemandName]           = useState(demand.name)
    const [demandAnchorText, setDemandAnchorText] = useState(demand.anchorText)
    const [demandUrl, setDemandUrl]             = useState(demand.url)
    const [demandDaNeeded, setDemandDaNeeded]   = useState(demand.daNeeded)
    const todayStr = new Date().toISOString().split('T')[0]
    const existingDate = demand.requested ? new Date(demand.requested).toISOString().split('T')[0] : null
    const [dateMode, setDateMode]               = useState(existingDate && existingDate !== todayStr ? 'specify' : 'today')
    const [demandRequested, setDemandRequested] = useState(existingDate ?? todayStr)
    const [demandWordCount, setWordCount]       = useState(demand.wordCount)
    const [errorMessage, setErrorMessage]       = useState()

    function submitHandler() {
        const requestedDate = new Date(dateMode === 'today' ? todayStr : demandRequested)
        demand.requested    = requestedDate.toISOString()
        demand.daNeeded     = demandDaNeeded
        demand.name         = demandName
        demand.url          = demandUrl
        demand.anchorText   = demandAnchorText
        demand.wordCount    = demandWordCount

        fixForPosting(demand)

        if (demand.id) {
            delete demand._links
            demand.updatedBy = user.email
            fetchWithAuth('/.rest/demands/' + demand.id, {
                method: 'PATCH',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(demand)
            }).then(resp => {
                if (resp.ok) {
                    successHandler ? successHandler() : (location.href = '/demand');
                } else {
                    setErrorMessage('Update failed: ' + resp.statusText)
                }
            })
        } else {
            demand.createdBy = user.email
            demand.source    = 'SlinkyLinky'
            fetchWithAuth('/.rest/demands', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(demand)
            }).then(resp => {
                if (resp.ok) {
                    location.href = '/demand';
                } else {
                    setErrorMessage('Create failed: ' + resp.statusText)
                }
            })
        }
    }

    function demandsiteSelectedHandler(demandsite) {
        setDemandsite(demandsite)
        setSearchTerm(demandsite.name)
        setDemandName(demandsite.name)
        demand.categories = demandsite.categories.filter(c => c.disabled == false)
    }

    function categoryChangeHandler(categories) {
        demand.categories = categories.map(c => c.value)
    }

    const fieldsEnabled = editMode || !!demandsite;
    const canSubmit     = editMode || !!demandsite;

    return (
        <>
        {demand ?
            <div className="flex gap-6 p-4">

                {/* ── Form panel ── */}
                <div className="w-full md:w-1/2 shrink-0">
                    <div className="card p-6 space-y-5">
                        <h2 className="text-base font-semibold text-gray-800">
                            {editMode ? 'Edit demand' : 'New demand'}
                        </h2>

                        {/* Name */}
                        {demandsite
                            ? <div className="flex flex-col gap-1">
                                <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Name</span>
                                <p id="nameLbl" className="text-sm font-medium text-gray-800">{demandsite.name}</p>
                              </div>
                            : <TextInput id="name" label="Name" binding={demandName}
                                disabled={editMode}
                                changeHandler={e => { setDemandName(e); setSearchTerm(e); }}/>
                        }

                        {/* Anchor text + URL */}
                        <TextInput id="anchorText" label="Anchor text" binding={demandAnchorText}
                            disabled={!fieldsEnabled}
                            changeHandler={setDemandAnchorText}/>

                        <TextInput id="url" label="URL" binding={demandUrl}
                            disabled={!fieldsEnabled}
                            changeHandler={setDemandUrl}/>

                        {/* Word count + DA */}
                        <div className="flex justify-between flex-wrap gap-4">
                            <NumberInput id="wordCount" label="Word count"
                                binding={demandWordCount} disabled={!fieldsEnabled}
                                changeHandler={setWordCount}
                                options={[500, 750, 1000, 1250, 1500]} color="blue"/>
                            <NumberInput id="daNeeded" label="DA needed"
                                binding={demandDaNeeded} disabled={!fieldsEnabled}
                                changeHandler={setDemandDaNeeded}
                                options={[10, 20, 30, 40, 50]} color="amber"/>
                        </div>

                        {/* Requested date */}
                        <div className="flex flex-col gap-2">
                            <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Requested</span>
                            <div className="flex gap-2">
                                {['today', 'specify'].map(mode => (
                                    <button key={mode} type="button"
                                        onClick={() => { if (fieldsEnabled) setDateMode(mode) }}
                                        disabled={!fieldsEnabled}
                                        className={`flex items-center gap-2 px-4 py-2 rounded-full text-sm font-medium border transition-colors
                                            ${!fieldsEnabled
                                                ? 'opacity-40 cursor-not-allowed bg-gray-100 text-gray-400 border-gray-200'
                                                : dateMode === mode
                                                    ? 'bg-indigo-600 text-white border-indigo-600'
                                                    : 'bg-white text-gray-600 border-gray-300 hover:border-indigo-400 hover:text-indigo-600'
                                            }`}
                                    >
                                        <span className={`w-3.5 h-3.5 rounded-full border-2 flex items-center justify-center shrink-0
                                            ${dateMode === mode && fieldsEnabled ? 'border-white' : 'border-current'}`}>
                                            {dateMode === mode && <span className="w-1.5 h-1.5 rounded-full bg-current"/>}
                                        </span>
                                        {mode === 'today' ? 'Today' : 'Specify'}
                                    </button>
                                ))}
                            </div>
                            {dateMode === 'specify' &&
                                <input id="requested" type="date"
                                    onChange={e => setDemandRequested(e.target.value)}
                                    value={demandRequested}
                                    disabled={!fieldsEnabled}
                                    className={`w-full rounded-lg border px-3 py-2 text-sm text-gray-800
                                        focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-colors
                                        ${!fieldsEnabled
                                            ? 'bg-gray-50 border-gray-200 text-gray-400 cursor-not-allowed'
                                            : 'bg-white border-gray-200 hover:border-gray-300'
                                        }`}
                                />
                            }
                        </div>

                        {/* Categories */}
                        {demand.categories && demand.categories.length > 0 &&
                            <div className="flex flex-col gap-1">
                                <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Categories</span>
                                <CategoriesCard categories={demand.categories}/>
                            </div>
                        }

                        {/* Error + submit */}
                        {errorMessage &&
                            <ErrorMessage message={errorMessage}/>
                        }
                        <div className="pt-2">
                            <StyledButton submitHandler={submitHandler} enabled={canSubmit} label="Save demand" type="primary" id="createnew"/>
                        </div>
                    </div>
                </div>

                {/* ── Demand site finder (new mode only) ── */}
                {!editMode &&
                    <div className="flex-1 min-w-0">
                        <DemandSiteFinder searchTerm={searchTerm} demandsiteSelectedHandler={demandsiteSelectedHandler}/>
                    </div>
                }
            </div>
        :
            <Loading/>
        }
        </>
    );
}
