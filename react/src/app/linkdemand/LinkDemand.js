'use client'

import React from 'react';
import './LinkDemand.css';
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
        const url = 'http://localhost:8080/linkdemands/search/findUnsatisfiedDemand';

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
                        <PageTitle title="Demand"/>
                        <div className="absolute top-4 right-4">
                            <Link href='/demand/Add'>
                                <button id="createnew" className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded">
                                    New
                                </button>
                            </Link>
                        </div>
                        <div className="grid grid-cols-2">
                        {this.state.linkdemands._embedded.linkdemands.map(ld => (
                            <div key={"li-"+this.parseId(ld)}>
                                <a href={'/supplier/search/'+this.parseId(ld)}>
                                    <LinkDemandCard linkdemand={ld} key={"ldc-"+this.parseId(ld)} />
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