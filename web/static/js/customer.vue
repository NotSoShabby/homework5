<template>
<div>
  <div class="form-group">
    <label class="control-label col-sm-3" for="pickup_address">Pickup address:</label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="pickup_address" v-model="pickup_address">
    </div>
  </div>
  <div class="form-group">
    <label class="control-label col-sm-3" for="dropoff_address">Drop off address:</label>
    <div class="col-sm-9">
      <input type="text" class="form-control" id="dropoff_address" v-model="dropoff_address">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button class="btn btn-default" v-on:click="submitBookingRequest">Submit</button>
    </div>
  </div>
  <div><textarea class="col-sm-12" style="background-color:#f4f7ff" rows="4" v-model="messages"></textarea></div>
  <div id="map" style="width:100%;height:300px"></div>
</div>
</template>

<script>
import axios from "axios";
import auth from "./auth";

export default {
    data: function() {
        return {
            pickup_address: "Liivi 2, Tartu, Estonia",
            dropoff_address: "",
            messages: ""
        }
    },
    methods: {
        submitBookingRequest: function() {
            axios.post("/api/bookings",
                {pickup_address: this.pickup_address, dropoff_address: this.dropoff_address},
                {headers: auth.getAuthHeader()})
                .then(response => {
                    this.messages = response.data.msg;
                }).catch(error => {
                    console.log(error);
                });
        }
    },
    mounted: function() {
        if (auth.socket) {
            var channel = auth.getChannel("customer:");
            channel.join()
                .receive("ok", resp => { console.log("Joined successfully", resp) })
                .receive("error", resp => { console.log("Unable to join", resp) });

            channel.on("requests", payload => {
                this.messages += "\n" + payload.msg;
            });
        }
    }
}
</script>