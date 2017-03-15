from django.conf import settings
from django.conf.urls import include, url
from django.conf.urls.static import static
from django.views.generic import TemplateView
from django.contrib import admin


admin.autodiscover()

urlpatterns = [
    url(r'^$', TemplateView.as_view(template_name='home.html')),
    url(r'^things/', include('onbuild.things.urls', namespace='things')),
    url(r'^admin/', include(admin.site.urls)),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
