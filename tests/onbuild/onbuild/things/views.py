from django.urls import reverse_lazy
from vanilla import ListView, CreateView, DetailView, UpdateView, DeleteView
from .forms import ThingForm
from .models import Thing


class ThingList(ListView):
    model = Thing
    paginate_by = 20


class ThingCreate(CreateView):
    model = Thing
    form_class = ThingForm
    success_url = reverse_lazy('things:list')


class ThingDetail(DetailView):
    model = Thing


class ThingUpdate(UpdateView):
    model = Thing
    form_class = ThingForm
    success_url = reverse_lazy('things:list')


class ThingDelete(DeleteView):
    model = Thing
    success_url = reverse_lazy('things:list')
