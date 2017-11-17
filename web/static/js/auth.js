import axios from "axios";
import {Socket} from "phoenix";

export default {
  user: { role: "", username: "" },
  socket: null, 
  login: function (context, creds, redirect) {
    axios.post("/api/sessions", creds)
      .then(response => {
        this.user.username = creds.username;
        this.user.role = response.data.role;
        window.localStorage.setItem('token-'+this.user.username, response.data.token);

        this.socket = new Socket("/socket", {params: {token: response.data.token}});
        this.socket.connect();
        if (redirect)
          context.$router.push({path: redirect});
      })
      .catch(error => {
        console.log(error);
      });
  },
  logout: function(context, options) {
    axios.delete("/api/sessions/1", options)
      .then(response => {
        window.localStorage.removeItem('token-'+this.user.username);
        this.user.authenticated = false;
        this.user.username = "";
        this.socket = null;
        context.$router.push({path: '/login'});
      }).catch(error => {
        console.log(error)
      });
  },
  getChannel: function(prefix) {
    var token = window.localStorage.getItem('token-'+this.user.username);
    var channel = this.socket.channel(prefix + this.user.username, { guardian_token: token });
    return channel;
  },
  authenticated: function() {
    const jwt = window.localStorage.getItem('token-'+this.user.username);
    return !!jwt;
  },
  getAuthHeader: function() {
    return {
      "Authorization": window.localStorage.getItem('token-'+this.user.username)
    }
  }
}