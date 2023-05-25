/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# CDN load balancer with Cloud bucket as backend

resource "google_project" "my_project" {
  name       = "My Project"
  project_id = "shweta-terraform-project"
}

#[START firestore_create_database]
resource "google_project_service" "firestore" {
  project ="shweta-terraform-project"
  service = "firestore.googleapis.com"
}

resource "google_firestore_database" "database" {
  project     = "shweta-terraform-project"
  name        = "(default)"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"
  app_engine_integration_mode = "DISABLED"

  depends_on = [google_project_service.firestore]
}
#[END  firestore_create_database]

#[START firestore_add_document]
resource "google_firestore_document" "mydoc" {
  project     = "shweta-terraform-project"
  collection  = "chatrooms"
  document_id = "my-doc-id"
  fields      =  "{\"something\":{\"mapValue\":{\"fields\":{\"name\":{\"stringValue\":\"Ben\"}}}}}"
}
#[END firestore_add_document]

# #[START firestore_create_single_field_index]
# resource "google_firestore_field" "basic" {
#   project = "shweta-terraform-project"
#   database = "(default)"
#   collection = "chatrooms_%{random_suffix}"
#   field = "name"

#   index_config {
#     indexes {
#         order = "ASCENDING"
#         query_scope = "COLLECTION_GROUP"
#     }
#     indexes {
#         array_config = "CONTAINS"
#     }
#   }

#   ttl_config {}
# }

#[END firestore_create_single_field_index]


#[START  firestore_create_composite_index]
resource "google_firestore_index" "my-index" {
  project = "shweta-terraform-project"

  collection = "chatrooms"

  fields {
    field_path = "name"
    order      = "ASCENDING"
  }

  fields {
    field_path = "description"
    order      = "DESCENDING"
  }

}
#[END firestore_create_composite_index]