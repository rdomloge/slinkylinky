import { useState } from "react";
import { DisableableSubmitButton, StyledButton } from "./atoms/Button";
import Modal from "./atoms/Modal";
import { useSession } from "next-auth/react";
import Loading from "./Loading";


export default function ContentCreator({dismissHandler, submitHandler, proposal}) {

    const { data: session } = useSession();
    const [prompt, setPrompt] = useState()
    const [content, setContent] = useState()
    const [error, setError] = useState(null)
    const [loading, setLoading] = useState(false)

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    function generate() {
        setLoading(true)
        const url = "/.rest/aisupport/generate";
        fetch(url, {
            method: 'POST',
            headers: {'user': session.user.email, 
                        'Content-Type':'text/plain',
                        'proposalId': parseId(proposal)},
            body: prompt
        ***REMOVED***)
            .then( (res) => res.text())
            .then( (text) => {
                setLoading(false)
                setContent(text)
        ***REMOVED***)
            .catch( (err) => {
                setLoading(false)
                setError(err)
        ***REMOVED***);
***REMOVED***

    function buildPrompt() {
        var prompt = "Using markdown, write a ~600 word article, in UK English, titled '[TITLE]' for a UK audience without mentioning the UK."
        proposal.paidLinks.forEach( (pl,index) => {
            prompt += " Include a link to ["+pl.demand.url+"] with the anchor text '"+pl.demand.anchorText+"' in a section on [SECTION]."
    ***REMOVED***)
        return prompt
***REMOVED***


    return (
        <Modal title={"AI content generator"} width={"w-4/5"} dismissHandler={dismissHandler}>
            <label htmlFor="content" className="block mb-2 text-sm font-medium text-gray-900 dark:text-white mt-4">Chat GPT output</label>
            <textarea id="content" rows="16" placeholder="Generated content (feel free to edit)" value={content} onChange={(e)=>setContent(e.target.value)}
                className="block p-2.5 w-full text-sm font-mono mr-8 text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
            </textarea>
            
            <label htmlFor="prompt" className="block mb-2 text-sm font-medium text-gray-900 dark:text-white mt-4">Your prompt</label>
            <textarea value={prompt} onChange={(e)=>setPrompt(e.target.value)} id="prompt" rows="4"
                defaultValue={buildPrompt()}
                className="block p-2.5 w-full text-sm font-mono mr-8 text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
            </textarea>

            <div className="flex">
                <div className="flex-0">
                    <StyledButton submitHandler={generate} enabled={prompt != null} label="Generate" type="secondary"/>
                </div>
                <div className="flex-0 ml-auto mr-0 cursor-default">
                    <StyledButton submitHandler={()=>submitHandler(content)} enabled={(content != null && content.length > 300)} label="Submit" type="primary"/>
                </div>
            </div>
            {error ? <Loading error={error}/> 
            : 
                loading ? <Loading/> : null
        ***REMOVED***
        </Modal>
    );
}