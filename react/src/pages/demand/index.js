'use client'

import React from 'react';
import LinkDemandCard from '@/components/linkdemandcard';
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout';
import Link from 'next/link';

class LinkDemand extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            error: null,
            isLoaded: false,
            linkdemands: []
    ***REMOVED***;
        this.myRef = React.createRef();
***REMOVED***

    componentDidMount() {
        const url = 'http://localhost:8080/linkdemands/search/findUnsatisfiedDemand?projection=fullLinkDemand';

        fetch(url)
            .then(res => res.json())
            .then((result) => this.setState({
                    isLoaded: true, 
                    linkdemands: result})
            ).catch(error => this.myRef.current.innerHTML = 'Error connecting to API: '+ error);
***REMOVED***

    parseId(linkdemand) {
        const url = linkdemand._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    render() {
        const { isLoaded, club } = this.state;
        if (!isLoaded) {
            return <div ref={this.myRef}>Loading...</div>;
    ***REMOVED*** else {
            return (
                <>
                    <Layout>
                        <PageTitle title={"Demand ("+this.state.linkdemands.length+")"}/>
                        <div className="inline-block content-center">
                            <Link href='/demand/Add'>
                                <button id="createnew" className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded">
                                    New
                                </button>
                            </Link>
                        </div>
                        <div className="grid grid-cols-2">
                        {this.state.linkdemands.map( (ld,index) => (
                            <div key={"li-"+index}>
                                <a href={'/supplier/search/'+ld.id}>
                                    <LinkDemandCard linkdemand={ld} key={index} />
                                </a>
                            </div>
                        ))}
                        </div>
                    </Layout>
                </>
            )
    ***REMOVED***
***REMOVED***
}

export default LinkDemand;