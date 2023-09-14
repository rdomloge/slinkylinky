import React from 'react';
import Contact from './contact/Contact';
import ClubSession from './ClubSession';

class Club extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            error: null,
            isLoaded: false,
            club: {}
    ***REMOVED***;
***REMOVED***

    componentDidMount() {
        const url = 'http://smy-server.10.0.0.12.xip.io/clubs/search/findClubByClubIdAndSeasonId?clubId=13&season=0';

        fetch(url)
            .then(res => res.json())
            .then((result) => this.setState({
                    isLoaded: true, 
                    club: result})
            ).catch(error => this.state.error = error);
***REMOVED***

    render() {
        const { error, isLoaded, club } = this.state;
        if (error != null) {
          return <div>Error: {error.message}</div>;
    ***REMOVED*** else if (!isLoaded) {
          return <div>Loading...</div>;
    ***REMOVED*** else {
          return (
            <div>
                {this.state.club.clubName}
                Club sessions
                <div>
                    {club.clubSessions.map(sesh => <ClubSession {...sesh}{...{title: 'Club sessions'}} key="{sesh.days}"/>)}
                </div>
                <div>
                    {club.matchSessions.map(sesh => <ClubSession {...sesh}{...{title: 'Match sessions'}} key="{sesh.days}"/>)}
                </div>

                
                <Contact {...this.state.club.chairMan}{...{role: 'Chairman'}} key="1"/>
                <Contact {...this.state.club.treasurer}{...{role: 'Treasurer'}} key="2"/>
                <Contact {...this.state.club.secretary}{...{role: 'Secretary'}} key="3"/>
                <Contact {...this.state.club.matchSec}{...{role: 'Match Secretary'}} key="4"/>
            </div>
          );
    ***REMOVED***
  ***REMOVED***
 }

 export default Club;