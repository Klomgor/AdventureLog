# Generated by Django 5.0.8 on 2024-08-19 20:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('adventures', '0003_adventure_end_date'),
    ]

    operations = [
        migrations.AddField(
            model_name='transportation',
            name='end_date',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]