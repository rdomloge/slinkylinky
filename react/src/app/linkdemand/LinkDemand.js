'use client'

import React from 'react';
import './LinkDemand.css';
import LinkDemandCard from '@/components/linkdemandcard';
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout';

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
                        <ul>
                            {this.state.linkdemands._embedded.linkdemands.map(ld => (
                                <li key={"li-"+this.parseId(ld)}>
                                    <a href={'/supplier/search/'+this.parseId(ld)}>
                                        <LinkDemandCard linkdemand={ld} key={"ldc-"+this.parseId(ld)} />
                                    </a>
                                </li>
                            ))}
                        </ul>
                    </Layout>
                </>
            )
        ***REMOVED***
***REMOVED***
}

export default LinkDemand;