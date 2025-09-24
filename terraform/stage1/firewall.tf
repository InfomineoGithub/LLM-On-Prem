# -----------------------------------------------------------------------------
# Firewall Rules
# -----------------------------------------------------------------------------

# --- Ingress Rules ---

# Rule to allow inbound HTTP traffic from any source to tagged nodes.
resource "google_compute_firewall" "allow_http_ingress" {
  name      = "${var.network_name}-allow-http-ingress"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-nodes"]
}

# Rule to allow inbound HTTPS traffic from any source to tagged nodes.
resource "google_compute_firewall" "allow_https_ingress" {
  name      = "${var.network_name}-allow-https-ingress"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-nodes"]
}

# Rule to allow inbound SSH traffic from any source to tagged nodes.
# WARNING: For production, it's highly recommended to restrict source_ranges
# to a list of specific, trusted IP addresses instead of "0.0.0.0/0".
resource "google_compute_firewall" "allow_ssh_ingress" {
  name      = "${var.network_name}-allow-ssh-ingress"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-nodes"]
}

# --- Egress Rules ---

# Rule to allow outbound HTTP traffic from tagged nodes to any destination.
resource "google_compute_firewall" "allow_http_egress" {
  name      = "${var.network_name}-allow-http-egress"
  network   = google_compute_network.vpc_network.name
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["gke-nodes"]
}

# Rule to allow outbound HTTPS traffic from tagged nodes to any destination.
resource "google_compute_firewall" "allow_https_egress" {
  name      = "${var.network_name}-allow-https-egress"
  network   = google_compute_network.vpc_network.name
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["gke-nodes"]
}

# Rule to allow outbound SSH traffic from tagged nodes to any destination.
resource "google_compute_firewall" "allow_ssh_egress" {
  name      = "${var.network_name}-allow-ssh-egress"
  network   = google_compute_network.vpc_network.name
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["gke-nodes"]
}
