<template>
<div>
  <customer v-if="getUserRole() === 'customer'"></customer>
  <driver v-if="getUserRole() === 'taxi-driver'"></driver>
  <div>
    <p class="pull-right">Already tired? <a href="/login" @click.prevent="logout">Log out!</a></p>
  </div>
</div>  
</template>
<script>
import auth from "./auth";

export default {
    methods: {
        logout: function() {
            auth.logout(this, { headers: auth.getAuthHeader() });
        },
        getUserRole: () => auth.user.role
    }
}
</script>