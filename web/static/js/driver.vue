<template>
<div class="well">
  <div class="alert alert-info" v-if="visible">
    New booking request.
    <li>Pickup address: <strong>{{pickup_address}}</strong>,</li>
    <li>dropoff address: <strong>{{dropoff_address}}</strong></li>
    <button class="btn btn-default" v-on:click="submitDecision({status: 'accepted'})">Accept</button>
    <button class="btn btn-danger" v-on:click="submitDecision({status: 'rejected'})">Reject</button>
  </div>
  <div id="map-driver" style="width:100%;height:300px"></div>
</div>
</template>
<script>
import axios from "axios";
import auth from "./auth";
// import socket from "./socket";

export default {
  data: function() {
    return {
      pickup_address: "",
      dropoff_address: "",
      visible: false,
      message: null
    }
  },
  methods: {
    submitDecision: function (decision) {
      if (this.message) {
        axios.patch("/api/bookings/" +this.message.booking_id, 
            {status: decision.status}, {headers: auth.getAuthHeader()})
        .then( response => {
            console.log("Received:", response );
        }).catch( e => console.log("Oops"));
        this.message = null;
        this.visible = false;
      }
    }
  },
  mounted: function() {
    if (auth.socket) {
        var channel = auth.getChannel("driver:");
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) });
        channel.on("requests", payload => {
            this.visible = true;
            this.pickup_address = payload.pickup_address;
            this.dropoff_address = payload.dropoff_address;
            this.message = payload;
        });
    }
  }
}
</script>