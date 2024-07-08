# Generated by Django 5.0.6 on 2024-06-28 18:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('adventures', '0003_adventure_is_public'),
    ]

    operations = [
        migrations.AddField(
            model_name='adventure',
            name='latitude',
            field=models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True),
        ),
        migrations.AddField(
            model_name='adventure',
            name='longitude',
            field=models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True),
        ),
    ]