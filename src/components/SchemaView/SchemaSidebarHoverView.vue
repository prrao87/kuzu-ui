<template>
  <div>
    <div>
      <h5>
        <span
          class="badge bg-primary"
          :style="{
            backgroundColor: ` ${getColor(hoveredLabel)} !important`,
            color: hoveredIsNode ? '#ffffff' : '#000000',
          }"
        >
          {{ hoveredLabel }}
        </span>
      </h5>
      <hr />

      <div v-if="!hoveredIsNode">
        <h6>
          <span
            class="badge bg-primary"
            :style="{
              backgroundColor: ` ${getColor(source)} !important`,
            }"
          >
            {{ source }}
          </span>
          &nbsp;
          <i class="fa-solid fa-arrow-right"></i>
          &nbsp;
          <span
            class="badge bg-primary"
            :style="{
              backgroundColor: ` ${getColor(destination)} !important`,
            }"
          >
            {{ destination }}
          </span>
        </h6>
        <br />
      </div>

      <table
        class="table table-sm table-bordered schema_side-panel__overview-table"
        v-if="schema"
      >
        <thead>
          <tr v-if="tableProperties.length > 0">
            <th scope="col">Name</th>
            <th scope="col">Type</th>
          </tr>
          <tr v-else>
            <th scope="col">There is no property in this table</th>
          </tr>
        </thead>
        <tbody v-if="tableProperties.length > 0">
          <tr v-for="property in tableProperties" :key="property.name">
            <td scope="row">
              {{ property.name }}
              <span class="badge bg-primary" v-if="property.isPrimaryKey"> PK </span>
            </td>
            <td>
              {{ property.type }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script lang="js">
import { useSettingsStore } from "../../store/SettingsStore";
import { mapStores } from 'pinia'
export default {
  name: "SchemaSidebarOverview",
  props: {
    schema: {
      type: Object,
      required: true,
    },
    hoveredLabel: {
      type: String,
      required: true,
    },
    hoveredIsNode: {
      type: Boolean,
      required: true,
    },
  },
  computed: {
    ...mapStores(useSettingsStore),
    source() {
      if (!this.schema || !this.hoveredLabel || this.hoveredIsNode) {
        return null;
      }
      return this.schema.relTables.find(t => t.name === this.hoveredLabel).src;
    },

    destination() {
      if (!this.schema || !this.hoveredLabel || this.hoveredIsNode) {
        return null;
      }
      return this.schema.relTables.find(t => t.name === this.hoveredLabel).dst;
    },

    tableProperties() {
      if (!this.schema || !this.hoveredLabel) {
        return [];
      }
      if (this.hoveredIsNode) {
        return this.schema.nodeTables
          .find(t => t.name === this.hoveredLabel)
          .properties;
      } else {
        return this.schema.relTables
          .find(t => t.name === this.hoveredLabel)
          .properties;
      }
    },
  },
  methods: {
    getColor(label) {
      return this.settingsStore.colorForLabel(label);
    },
  },
};
</script>

<style scoped lang="scss"></style>
