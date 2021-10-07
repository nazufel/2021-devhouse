# diagram.py

# script to build the architecture diagram

from diagrams import Cluster, Diagram
from diagrams.gcp.analytics import PubSub
from diagrams.gcp.compute import GCE, GKE
from diagrams.gcp.database import Datastore, Memorystore
from diagrams.onprem.client import User

with Diagram("", show=False, filename="diagram2", direction='LR'):

	user = User("user")

	with Cluster("Google Cloud Platform"):
		
		gke = GKE("K8s Clusters")

		with Cluster("Scylla Database Cluster"):

			db_cluster = GCE("db*")

		with Cluster("Other GCP Services"):
			cache = Memorystore("")
			db = Datastore("")
			pb = PubSub("")


	user >> gke
	gke >> db_cluster
	gke >> pb
	gke >> cache
	gke >> db
#EOF