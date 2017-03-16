from django.conf.urls import url
from . import views


urlpatterns = [
    url(r'^$', views.ThingList.as_view(), name='list'),
    url(r'^new/$', views.ThingCreate.as_view(), name='create'),
    url(r'^(?P<pk>\d+)/$', views.ThingDetail.as_view(), name='detail'),
    url(r'^(?P<pk>\d+)/update/$', views.ThingUpdate.as_view(), name='update'),
    url(r'^(?P<pk>\d+)/delete/$', views.ThingDelete.as_view(), name='delete'),
]
